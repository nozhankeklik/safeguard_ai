import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:safeguard_ai/core/constants/app_constants.dart';
import 'package:safeguard_ai/core/init/injection_container.dart' as di;
import 'package:safeguard_ai/core/utils/email_template_generator.dart';
import 'package:safeguard_ai/features/analysis/data/datasources/report_remote_datasource.dart';
import 'package:safeguard_ai/features/analysis/data/models/report_hive_model.dart';
import 'package:safeguard_ai/features/analysis/data/models/send_report_request.dart';
import 'package:safeguard_ai/features/analysis/data/repositories/report_local_repository.dart';
import 'package:safeguard_ai/features/analysis/domain/entities/analysis_entity.dart';

class ReportPreviewPage extends StatefulWidget {
  final AnalysisEntity analysis;
  final String imagePath;

  const ReportPreviewPage({super.key, required this.analysis, required this.imagePath});

  @override
  State<ReportPreviewPage> createState() => _ReportPreviewPageState();
}

class _ReportPreviewPageState extends State<ReportPreviewPage> {
  late TextEditingController _subjectController;
  late TextEditingController _bodyController;
  late List<String> _recipients;
  late List<String> _ccRecipients;
  bool _saveToGoogleDrive = false;
  bool _generatePdf = false;
  bool _createFollowUp = false;
  bool _isLoading = false;

  // Dependencies
  late final ReportRemoteDataSource _reportDataSource;
  late final ReportLocalRepository _reportRepository;

  @override
  void initState() {
    super.initState();

    // Dependencies
    _reportDataSource = di.sl<ReportRemoteDataSource>();
    _reportRepository = di.sl<ReportLocalRepository>();

    // Otomatik mail şablonlarını oluştur
    final subject = EmailTemplateGenerator.generateSubject(widget.analysis.riskLevel);
    final body = EmailTemplateGenerator.generateBody(widget.analysis, DateTime.now());
    final defaultRecipients = EmailTemplateGenerator.getDefaultRecipients(widget.analysis.riskLevel);

    _subjectController = TextEditingController(text: subject);
    _bodyController = TextEditingController(text: body);
    _recipients = List.from(defaultRecipients);
    _ccRecipients = [];
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  /// Risk seviyesine göre primary renk döndürür (monokrom - primary color)
  Color _getRiskColor(String riskLevel) {
    return Theme.of(context).colorScheme.primary;
  }

  /// Risk seviyesine göre arka plan rengi (monokrom - light gray)
  Color _getRiskBackgroundColor(String riskLevel) {
    return Colors.grey.shade50;
  }

  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'YÜKSEK':
      case 'HIGH':
        return Icons.dangerous;
      case 'ORTA':
      case 'MEDIUM':
        return Icons.warning_amber_rounded;
      case 'DÜŞÜK':
      case 'LOW':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  Future<void> _addRecipient() async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return _AddRecipientDialog(
          existingRecipients: _recipients,
          onAdd: (email) {
            setState(() {
              _recipients.add(email);
            });
            Navigator.pop(dialogContext);
            _showSuccessSnackBar('Alıcı eklendi: $email');
          },
        );
      },
    );
  }

  Future<void> _addCcRecipient() async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return _AddCcRecipientDialog(
          existingRecipients: _recipients,
          existingCcRecipients: _ccRecipients,
          onAdd: (email) {
            setState(() {
              _ccRecipients.add(email);
            });
            Navigator.pop(dialogContext);
            _showSuccessSnackBar('CC eklendi: $email');
          },
        );
      },
    );
  }

  /// Hata mesajı göster
  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Başarı mesajı göster
  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Raporu gönder (validasyonlarla)
  Future<void> _sendReport() async {
    // Validasyon 1: Alıcı kontrolü
    if (_recipients.isEmpty) {
      _showErrorSnackBar('En az bir alıcı eklemelisiniz');
      return;
    }

    // Validasyon 2: Mail başlığı kontrolü
    final subject = _subjectController.text.trim();
    if (subject.isEmpty) {
      _showErrorSnackBar('Mail başlığı boş olamaz');
      return;
    }
    if (subject.length < AppConstants.minCharactersSubject) {
      _showErrorSnackBar('Mail başlığı en az ${AppConstants.minCharactersSubject} karakter olmalı');
      return;
    }

    // Validasyon 3: Mail içeriği kontrolü
    final body = _bodyController.text.trim();
    if (body.isEmpty) {
      _showErrorSnackBar('Mail içeriği boş olamaz');
      return;
    }
    if (body.length < AppConstants.minCharactersBody) {
      _showErrorSnackBar('Mail içeriği en az ${AppConstants.minCharactersBody} karakter olmalı');
      return;
    }

    // Validasyon 4: Resim dosyası kontrolü
    final imageFile = File(widget.imagePath);
    if (!imageFile.existsSync()) {
      _showErrorSnackBar('Resim dosyası bulunamadı');
      return;
    }

    // Loading başlat
    setState(() => _isLoading = true);

    try {
      // 1️⃣ n8n'e gönder
      // Email body'den analiz metnini çıkar (düzenlenmiş halini kullan)
      // Email body'de "TESPİT EDİLEN DURUM:" sonrası analiz metni var (çok satırlı olabilir)
      String editedAnalysis = widget.analysis.analysisText;
      final bodyLines = body.split('\n');
      int analysisStartIndex = -1;
      int analysisEndIndex = bodyLines.length;
      
      // "TESPİT EDİLEN DURUM" satırını bul
      for (int i = 0; i < bodyLines.length; i++) {
        final line = bodyLines[i].trim();
        if (line.contains('TESPİT EDİLEN DURUM') || 
            line.contains('Tespit Edilen Durum') ||
            line.contains('TESPİT') && line.contains('DURUM')) {
          analysisStartIndex = i + 1; // Bir sonraki satırdan başla
          break;
        }
      }
      
      // "RİSK SEVİYESİ" satırını bul (analiz metninin sonu)
      if (analysisStartIndex > 0) {
        for (int i = analysisStartIndex; i < bodyLines.length; i++) {
          final line = bodyLines[i].trim();
          if (line.contains('RİSK SEVİYESİ') || 
              line.contains('Risk Seviyesi') ||
              line.contains('RİSK') && line.contains('SEVİYESİ')) {
            analysisEndIndex = i;
            break;
          }
        }
        
        // Analiz metnini çıkar
        if (analysisStartIndex < analysisEndIndex) {
          editedAnalysis = bodyLines
              .sublist(analysisStartIndex, analysisEndIndex)
              .map((line) => line.trim())
              .where((line) => line.isNotEmpty)
              .join('\n')
              .trim();
        }
      }
      
      // Eğer analiz metni çok kısa veya bulunamadıysa, orijinal analizi kullan
      if (editedAnalysis.isEmpty || editedAnalysis.length < 10) {
        editedAnalysis = widget.analysis.analysisText;
      }

      final request = SendReportRequest(
        imagePath: widget.imagePath,
        analysis: editedAnalysis, // Düzenlenmiş analiz metni
        riskLevel: widget.analysis.riskLevel,
        emailSubject: subject,
        emailBody: body,
        recipients: _recipients,
        ccRecipients: _ccRecipients,
        saveToGoogleDrive: _saveToGoogleDrive,
        generatePdf: _generatePdf,
      );

      final response = await _reportDataSource.sendReport(request);

      // 2️⃣ Hive'a kaydet (local history)
      final reportId = const Uuid().v4();
      final hiveReport = ReportHiveModel(
        id: reportId,
        analysis: editedAnalysis, // Düzenlenmiş analiz metni
        riskLevel: widget.analysis.riskLevel,
        imagePath: widget.imagePath,
        timestamp: DateTime.now(),
        emailSubject: subject,
        emailBody: body,
        recipients: _recipients,
        ccRecipients: _ccRecipients,
        emailSent: response.emailSent,
        savedToGoogleDrive: response.driveFileCreated,
        pdfGenerated: response.pdfGenerated,
      );

      await _reportRepository.saveReport(hiveReport);

      // 3️⃣ Success dialog ve History'e git
      if (mounted) {
        _showSuccessDialogAndNavigate();
      }
    } catch (e) {
      // ❌ Error handling
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Başarı dialogu göster ve History'e yönlendir
  void _showSuccessDialogAndNavigate() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 32),
            const SizedBox(width: AppConstants.spacingMedium),
            const Text('Başarılı!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rapor başarıyla oluşturuldu ve gönderildi.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email, color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text('Email gönderildi', style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
            if (_saveToGoogleDrive) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.cloud_done, color: Theme.of(context).colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Google Drive\'a kaydedildi', style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ],
            if (_generatePdf) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Theme.of(context).colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('PDF oluşturuldu', style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go('/home');
            },
            child: const Text('Ana Sayfa'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go('/history');
            },
            style: ElevatedButton.styleFrom(backgroundColor: RiskColors.lowRiskPrimary, foregroundColor: Colors.white),
            child: const Text('Geçmişi Gör'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapor Önizleme'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Yardım'),
                  content: const Text(
                    'Bu sayfada:\n\n'
                    '• Mail içeriğini düzenleyebilirsiniz\n'
                    '• Alıcı ekleyip çıkarabilirsiniz\n'
                    '• Ek seçenekleri aktif edebilirsiniz\n\n'
                    'Rapor hazır olduğunda "Gönder" butonuna basın.',
                  ),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fotoğraf Önizleme
              Card(
                elevation: 4,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.file(File(widget.imagePath), width: double.infinity, height: 200, fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            dateFormat.format(DateTime.now()),
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Risk Seviyesi Badge
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingLarge),
                decoration: BoxDecoration(
                  color: _getRiskBackgroundColor(widget.analysis.riskLevel),
                  borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radiusMedium)),
                  border: Border.all(color: _getRiskColor(widget.analysis.riskLevel), width: 2),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getRiskIcon(widget.analysis.riskLevel),
                      color: _getRiskColor(widget.analysis.riskLevel),
                      size: AppConstants.iconSizeLarge,
                    ),
                    const SizedBox(width: AppConstants.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Risk Seviyesi',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            widget.analysis.riskLevel,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _getRiskColor(widget.analysis.riskLevel),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Mail Başlığı
              Text(
                'Mail Başlığı',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _subjectController,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Mail başlığını girin',
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 20),

              // Mail İçeriği
              Text(
                'Mail İçeriği',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _bodyController,
                maxLines: AppConstants.maxLinesEmailBody,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15, height: 1.5),
                decoration: InputDecoration(
                  hintText: 'Mail içeriğini girin',
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                  ),
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.all(AppConstants.spacingLarge),
                ),
              ),
              const SizedBox(height: 20),

              // Alıcılar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Alıcılar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(onPressed: _addRecipient, icon: const Icon(Icons.add), label: const Text('Ekle')),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _recipients.map((email) {
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  return Chip(
                    label: Text(email, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                    onDeleted: () {
                      setState(() {
                        _recipients.remove(email);
                      });
                    },
                    deleteIcon: Icon(Icons.close, size: 18, color: isDark ? Colors.white70 : Colors.black54),
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // CC Alıcıları
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CC (Opsiyonel)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(onPressed: _addCcRecipient, icon: const Icon(Icons.add), label: const Text('Ekle')),
                ],
              ),
              const SizedBox(height: 8),
              if (_ccRecipients.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _ccRecipients.map((email) {
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    return Chip(
                      label: Text(email, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                      onDeleted: () {
                        setState(() {
                          _ccRecipients.remove(email);
                        });
                      },
                      deleteIcon: Icon(Icons.close, size: 18, color: isDark ? Colors.white70 : Colors.black54),
                      backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    );
                  }).toList(),
                )
              else
                Text(
                  'CC alıcısı eklenmedi',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              const SizedBox(height: 24),

              // Ek Seçenekler
              Text(
                'Ek Seçenekler',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Google Drive\'a kaydet'),
                      subtitle: const Text('Rapor otomatik olarak Google Drive\'a kaydedilir'),
                      value: _saveToGoogleDrive,
                      onChanged: (value) {
                        setState(() {
                          _saveToGoogleDrive = value ?? false;
                        });
                      },
                      secondary: const Icon(Icons.cloud_upload),
                    ),
                    const Divider(height: 1),
                    CheckboxListTile(
                      title: const Text('PDF rapor oluştur'),
                      subtitle: const Text('Rapor PDF formatında oluşturulur'),
                      value: _generatePdf,
                      onChanged: (value) {
                        setState(() {
                          _generatePdf = value ?? false;
                        });
                      },
                      secondary: const Icon(Icons.picture_as_pdf),
                    ),
                    const Divider(height: 1),
                    CheckboxListTile(
                      title: const Text('Takip sistemi oluştur'),
                      subtitle: const Text('İlgili birimler için takip kaydı açılır'),
                      value: _createFollowUp,
                      onChanged: (value) {
                        setState(() {
                          _createFollowUp = value ?? false;
                        });
                      },
                      secondary: const Icon(Icons.flag),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Butonlar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('İptal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _sendReport,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: _getRiskColor(widget.analysis.riskLevel),
                        foregroundColor: Colors.white,
                      ),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.send),
                      label: Text(_isLoading ? 'Gönderiliyor...' : 'Gönder'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

/// Alıcı ekleme dialog widget'ı
class _AddRecipientDialog extends StatefulWidget {
  final List<String> existingRecipients;
  final Function(String) onAdd;

  const _AddRecipientDialog({required this.existingRecipients, required this.onAdd});

  @override
  State<_AddRecipientDialog> createState() => _AddRecipientDialogState();
}

class _AddRecipientDialogState extends State<_AddRecipientDialog> {
  late final TextEditingController _controller;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAdd() {
    final email = _controller.text.trim();

    // Validasyonlar
    if (email.isEmpty) {
      setState(() => _errorMessage = 'E-posta adresi boş olamaz');
      return;
    }

    if (!EmailTemplateGenerator.isValidEmail(email)) {
      setState(() => _errorMessage = 'Geçersiz e-posta formatı');
      return;
    }

    // Duplicate kontrolü
    if (widget.existingRecipients.contains(email)) {
      setState(() => _errorMessage = 'Bu e-posta zaten ekli');
      return;
    }

    // Başarılı
    widget.onAdd(email);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alıcı Ekle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'E-posta adresi',
              hintText: 'ornek@sirket.com',
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            onChanged: (_) {
              // Error'u temizle
              if (_errorMessage != null) {
                setState(() => _errorMessage = null);
              }
            },
            onSubmitted: (_) => _handleAdd(),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(_errorMessage!, style: TextStyle(color: Colors.red.shade700, fontSize: 12)),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        TextButton(onPressed: _handleAdd, child: const Text('Ekle')),
      ],
    );
  }
}

/// CC alıcı ekleme dialog widget'ı
class _AddCcRecipientDialog extends StatefulWidget {
  final List<String> existingRecipients;
  final List<String> existingCcRecipients;
  final Function(String) onAdd;

  const _AddCcRecipientDialog({
    required this.existingRecipients,
    required this.existingCcRecipients,
    required this.onAdd,
  });

  @override
  State<_AddCcRecipientDialog> createState() => _AddCcRecipientDialogState();
}

class _AddCcRecipientDialogState extends State<_AddCcRecipientDialog> {
  late final TextEditingController _controller;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAdd() {
    final email = _controller.text.trim();

    // Validasyonlar
    if (email.isEmpty) {
      setState(() => _errorMessage = 'E-posta adresi boş olamaz');
      return;
    }

    if (!EmailTemplateGenerator.isValidEmail(email)) {
      setState(() => _errorMessage = 'Geçersiz e-posta formatı');
      return;
    }

    // Duplicate kontrolü (CC listesinde ve TO listesinde)
    if (widget.existingCcRecipients.contains(email)) {
      setState(() => _errorMessage = 'Bu e-posta CC\'de zaten var');
      return;
    }

    if (widget.existingRecipients.contains(email)) {
      setState(() => _errorMessage = 'Bu e-posta ana alıcılarda zaten var');
      return;
    }

    // Başarılı
    widget.onAdd(email);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('CC Ekle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'E-posta adresi (CC)',
              hintText: 'ornek@sirket.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            onChanged: (_) {
              // Error'u temizle
              if (_errorMessage != null) {
                setState(() => _errorMessage = null);
              }
            },
            onSubmitted: (_) => _handleAdd(),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(_errorMessage!, style: TextStyle(color: Colors.red.shade700, fontSize: 12)),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        TextButton(onPressed: _handleAdd, child: const Text('Ekle')),
      ],
    );
  }
}
