import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:5678/webhook/analyze',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Future<Response?> uploadImage(String imagePath) async {
    try {
      final formData = FormData.fromMap({'data': await MultipartFile.fromFile(imagePath, filename: 'upload.jpg')});

      final response = await _dio.post('', data: formData);
      return response;
    } catch (e) {
      print('Upload image error: $e');
      return null;
    }
  }
}
