import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safeguard_ai/features/analysis/api_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  File? capturedImage;
  bool isAnalyzing = false;
  bool shouldShowCamera = true; // Safe Detach Sequence: Controls CameraPreview rendering
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Kamera iznini kontrol et
      final status = await Permission.camera.request();

      if (!status.isGranted) {
        print('Kamera izni verilmedi');
        return;
      }

      // Mevcut kamerları al
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        print('Kamera bulunamadı');
        return;
      }

      // Arka kamerayı bul
      CameraDescription? backCamera;
      for (var camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.back) {
          backCamera = camera;
          break;
        }
      }

      // Arka kamera bulunamazsa ilk kamerayı kullan
      backCamera ??= cameras.first;

      // Kamera controller'ı oluştur
      controller = CameraController(backCamera, ResolutionPreset.medium, enableAudio: false);

      // Kamera controller'ı başlat
      await controller!.initialize();

      if (mounted) {
        setState(() {
          shouldShowCamera = true;
        });
      }
    } catch (e) {
      // Simülatör veya kamera başlatılamama durumu
      print('Kamera başlatılamadı (Simülatör olabilir): $e');
    }
  }

  Future<void> _killCamera() async {
    if (controller != null) {
      try {
        await controller!.dispose();
      } catch (e) {
        print('Kamera dispose hatası: $e');
      }
    }
    controller = null;
  }

  Map<String, String> _parseGeminiResponse(dynamic responseData) {
    try {
      // Step 1: Try to decode responseData as JSON
      dynamic root;
      if (responseData is String) {
        root = jsonDecode(responseData);
      } else {
        root = responseData;
      }

      // Step 2: Navigate to root[0]['content']['parts'][0]['text']
      // Handle cases where root might be a Map or List
      dynamic firstItem;
      if (root is List && root.isNotEmpty) {
        firstItem = root[0];
      } else if (root is Map) {
        firstItem = root;
      } else {
        throw Exception('Unexpected root structure');
      }

      if (firstItem is! Map) {
        throw Exception('First item is not a Map');
      }

      final content = firstItem['content'];
      if (content is! Map) {
        throw Exception('Content is not a Map');
      }

      final parts = content['parts'];
      if (parts is! List || parts.isEmpty) {
        throw Exception('Parts is not a List or is empty');
      }

      final firstPart = parts[0];
      if (firstPart is! Map) {
        throw Exception('First part is not a Map');
      }

      final text = firstPart['text'];
      if (text is! String) {
        throw Exception('Text is not a String');
      }

      // Step 3: Clean Markdown - Remove ```json and ``` markers
      String cleanedText = text;
      cleanedText = cleanedText.replaceAll('```json', '');
      cleanedText = cleanedText.replaceAll('```', '');
      cleanedText = cleanedText.trim();

      // Step 4: Decode the cleaned text string (which should now be a raw JSON list)
      final jsonList = jsonDecode(cleanedText) as List;

      // Step 5: Extract the 'risk' and 'oneri' from the first item of that list
      if (jsonList.isEmpty) {
        throw Exception('JSON list is empty');
      }

      final firstJsonItem = jsonList[0] as Map<String, dynamic>;
      final risk = firstJsonItem['risk']?.toString() ?? 'Bilinmiyor';
      final oneri = firstJsonItem['oneri']?.toString() ?? 'Bilinmiyor';

      return {'risk': risk, 'oneri': oneri};
    } catch (e) {
      print('Gemini response parse hatası: $e');
      return {'risk': 'Analiz hatası', 'oneri': 'Veri ayrıştırılamadı'};
    }
  }

  Future<void> _onTakePicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      print('Kamera hazır değil');
      return;
    }

    try {
      // Step 1: Fotoğraf çek
      final XFile file = await controller!.takePicture();

      // Step 2: IMMEDIATELY remove preview from UI (physically detaches SurfaceTexture)
      if (mounted) {
        setState(() {
          shouldShowCamera = false;
        });
      }

      // Step 3: CRITICAL - Give hardware time to release the buffer
      await Future.delayed(const Duration(milliseconds: 200));

      // Step 4: Now safely dispose the camera
      await _killCamera();

      // Step 5: setState to show the capturedImage and set isAnalyzing = true
      if (mounted) {
        setState(() {
          capturedImage = File(file.path);
          isAnalyzing = true;
        });
      }

      print('FOTOĞRAF BAŞARIYLA ÇEKİLDİ! Dosya Yolu: ${file.path}');

      // Call _apiService.uploadImage
      final response = await _apiService.uploadImage(file.path);

      // Show the result in an AlertDialog
      if (mounted) {
        if (response != null) {
          // Parse the Gemini response
          final parsedData = _parseGeminiResponse(response.data);
          _showResultDialog(parsedData);
        } else {
          _showErrorDialog('Analiz başarısız oldu. Lütfen tekrar deneyin.');
        }
      }
    } catch (e) {
      print('Fotoğraf çekme hatası: $e');
      if (mounted) {
        _showErrorDialog('Fotoğraf çekme hatası: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          isAnalyzing = false;
        });
      }
    }
  }

  Future<void> _handleDialogClose() async {
    // Clear capturedImage and call _initializeCamera() to restart the preview
    if (mounted) {
      setState(() {
        capturedImage = null;
        shouldShowCamera = true;
      });
    }
    await _initializeCamera();
  }

  void _showResultDialog(Map<String, String> data) {
    final risk = data['risk'] ?? 'Bilinmiyor';
    final oneri = data['oneri'] ?? 'Bilinmiyor';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Analiz Sonucu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Risk: $risk',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Öneri: $oneri',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleDialogClose();
            },
            child: const Text('Tamam'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleDialogClose();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hata'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleDialogClose();
            },
            child: const Text('Tamam'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleDialogClose();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _killCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Ana içerik
          if (capturedImage != null)
            // Çekilen fotoğrafı göster (Statik resim)
            Stack(
              children: [
                // Fotoğraf
                SizedBox.expand(
                  child: Image.file(
                    capturedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
                // Yükleniyor göstergesi (API isteği sırasında)
                if (isAnalyzing)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            )
          else if (shouldShowCamera && controller != null && controller!.value.isInitialized)
            // Kamera önizlemesi (only render if shouldShowCamera is true)
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1 / controller!.value.aspectRatio,
                      child: CameraPreview(controller!),
                    ),
                  ),
                ),
                // Alt Kısım (Container) - Buton Alanı
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Center(
                    child: InkWell(
                      onTap: _onTakePicture,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: const Icon(Icons.camera, color: Colors.black, size: 40),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            // Black container (shown when shouldShowCamera is false - physically detaches SurfaceTexture)
            Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
