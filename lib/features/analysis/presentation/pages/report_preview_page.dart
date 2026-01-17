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
  late TextEditingController _finalMessageController; // V2: Sadece final_message (analiz metni)
  late List<String> _recipients;
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

    // V2: Basitleştirilmiş - sadece gerekli alanlar
    final subject = EmailTemplateGenerator.generateSubject(widget.analysis.riskLevel);
    // Default recipients için sync versiyon kullan (initState async olamaz)
    final defaultRecipients = EmailTemplateGenerator.getDefaultRecipientsSync(widget.analysis.riskLevel);

    _subjectController = TextEditingController(text: subject);
    _finalMessageController = TextEditingController(text: widget.analysis.analysisText);
    _recipients = List.from(defaultRecipients);

    // Async olarak SharedPreferences'tan güncel değerleri yükle
    _loadDefaultRecipients();
  }

  /// SharedPreferences'tan default recipients'ları yükle
  Future<void> _loadDefaultRecipients() async {
    final defaultRecipients = await EmailTemplateGenerator.getDefaultRecipients(widget.analysis.riskLevel);
    if (mounted) {
      setState(() {
        // Eğer recipients boşsa veya sadece eski default değerler varsa, yeni değerlerle güncelle
        if (_recipients.isEmpty || _recipients.length == 1 && _recipients.first == 'raporlama@sirket.com') {
          _recipients = List.from(defaultRecipients);
        }
      });
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _finalMessageController.dispose();
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

  /// V2 Backend - Raporu gönder (basitleştirilmiş validasyonlarla)
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

    // Validasyon 3: Final message (analiz metni) kontrolü
    final finalMessage = _finalMessageController.text.trim();
    if (finalMessage.isEmpty) {
      _showErrorSnackBar('Analiz metni boş olamaz');
      return;
    }
    if (finalMessage.length < AppConstants.minCharactersBody) {
      _showErrorSnackBar('Analiz metni en az ${AppConstants.minCharactersBody} karakter olmalı');
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
      // V2 Backend - Basitleştirilmiş request
      final request = SendReportRequest(
        imagePath: widget.imagePath,
        finalMessage: finalMessage, // Kullanıcının düzenlediği analiz metni
        riskLevel: widget.analysis.riskLevel,
        recipient: _recipients.first, // V2: Tek bir alıcı
        subject: subject,
      );

      final response = await _reportDataSource.sendReport(request);

      // Hive'a kaydet (local history)
      final reportId = const Uuid().v4();
      final hiveReport = ReportHiveModel(
        id: reportId,
        analysis: finalMessage,
        riskLevel: widget.analysis.riskLevel,
        imagePath: widget.imagePath,
        timestamp: DateTime.now(),
        emailSubject: subject,
        emailBody: finalMessage, // V2: Email body yok, sadece final_message
        recipients: _recipients,
        ccRecipients: [], // V2: CC yok
        emailSent: response.emailSent,
        savedToGoogleDrive: response.driveFileCreated,
        pdfGenerated: response.pdfGenerated,
      );

      await _reportRepository.saveReport(hiveReport);

      // Success dialog ve History'e git
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
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.cloud_done, color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Google Drive\'a kaydedildi', style: TextStyle(color: Colors.grey.shade700)),
                ),
              ],
            ),
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
                    '• Analiz metnini düzenleyebilirsiniz\n'
                    '• Mail başlığını değiştirebilirsiniz\n'
                    '• Alıcı ekleyip çıkarabilirsiniz\n\n'
                    'Rapor gönderildiğinde otomatik olarak:\n'
                    '• Google Drive\'a kaydedilir\n\n'
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

              // V2: Analiz Metni (Final Message) - Düzenlenebilir
              Text(
                'Analiz Metni',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'AI tarafından oluşturulan analiz metnini buradan düzenleyebilirsiniz.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _finalMessageController,
                maxLines: 8,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15, height: 1.5),
                decoration: InputDecoration(
                  hintText: 'Analiz metnini buradan düzenleyin...',
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
              const SizedBox(height: 24),

              // Otomatik İşlemler Bilgilendirmesi
              Card(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Otomatik İşlemler',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.cloud_done, size: 18, color: Colors.grey.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Rapor Google Drive\'a kaydedilir',
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
