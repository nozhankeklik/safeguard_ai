import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/init/injection_container.dart' as di;
import '../../../../core/utils/email_template_generator.dart';
import '../../data/datasources/report_remote_datasource.dart';
import '../../data/models/report_hive_model.dart';
import '../../data/models/send_report_request.dart';
import '../../data/repositories/report_local_repository.dart';
import '../../domain/entities/analysis_entity.dart';

class ReportPreviewPage extends StatefulWidget {
  final AnalysisEntity analysis;
  final String imagePath;

  const ReportPreviewPage({super.key, required this.analysis, required this.imagePath});

  @override
  State<ReportPreviewPage> createState() => _ReportPreviewPageState();
}

class _ReportPreviewPageState extends State<ReportPreviewPage> {
  late TextEditingController _subjectController;
  late TextEditingController _finalMessageController;
  late List<String> _recipients;
  bool _isLoading = false;

  late final ReportRemoteDataSource _reportDataSource;
  late final ReportLocalRepository _reportRepository;

  @override
  void initState() {
    super.initState();
    _reportDataSource = di.sl<ReportRemoteDataSource>();
    _reportRepository = di.sl<ReportLocalRepository>();

    final subject = EmailTemplateGenerator.generateSubject(widget.analysis.riskLevel);
    final defaultRecipients = EmailTemplateGenerator.getDefaultRecipientsSync(widget.analysis.riskLevel);

    _subjectController = TextEditingController(text: subject);
    _finalMessageController = TextEditingController(text: widget.analysis.analysisText);
    _recipients = List.from(defaultRecipients);

    _loadDefaultRecipients();
  }

  Future<void> _loadDefaultRecipients() async {
    final defaultRecipients = await EmailTemplateGenerator.getDefaultRecipients(widget.analysis.riskLevel);
    if (mounted) {
      setState(() {
        if (_recipients.isEmpty || (_recipients.length == 1 && _recipients.first.contains('raporlama'))) {
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

  // --- RENK YARDIMCILARI ---
  Color _getRiskColor(String riskLevel, bool isDark) {
    switch (riskLevel.toUpperCase()) {
      case 'YÜKSEK':
        return Theme.of(context).colorScheme.error;
      case 'ORTA':
        return isDark ? Colors.orangeAccent : Colors.orange.shade800;
      default:
        return isDark ? Colors.greenAccent : Colors.green.shade700;
    }
  }

  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'YÜKSEK':
        return Icons.warning_amber_rounded;
      case 'ORTA':
        return Icons.report_gmailerrorred_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }

  // --- İŞLEM FONKSİYONLARI ---

  Future<void> _addRecipient() async {
    await showDialog(
      context: context,
      builder: (context) => _AddRecipientDialog(
        existingRecipients: _recipients,
        onAdd: (email) {
          setState(() => _recipients.add(email));
          Navigator.pop(context);
          _showSuccessSnackBar('Alıcı eklendi');
        },
      ),
    );
  }

  Future<void> _sendReport() async {
    if (_recipients.isEmpty) {
      _showErrorSnackBar('En az bir alıcı gereklidir.');
      return;
    }
    if (_subjectController.text.isEmpty) {
      _showErrorSnackBar('Başlık boş olamaz.');
      return;
    }
    if (_finalMessageController.text.isEmpty) {
      _showErrorSnackBar('Analiz metni boş olamaz.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = SendReportRequest(
        imagePath: widget.imagePath,
        finalMessage: _finalMessageController.text.trim(),
        riskLevel: widget.analysis.riskLevel,
        recipient: _recipients.first,
        subject: _subjectController.text.trim(),
        correctiveActions: widget.analysis.correctiveActions,
      );

      final response = await _reportDataSource.sendReport(request);

      final hiveReport = ReportHiveModel(
        id: const Uuid().v4(),
        analysis: _finalMessageController.text.trim(),
        riskLevel: widget.analysis.riskLevel,
        imagePath: widget.imagePath,
        timestamp: DateTime.now(),
        emailSubject: _subjectController.text.trim(),
        emailBody: _finalMessageController.text.trim(),
        recipients: _recipients,
        ccRecipients: [],
        emailSent: response.emailSent,
        savedToGoogleDrive: response.driveFileCreated,
        pdfGenerated: false,
      );

      await _reportRepository.saveReport(hiveReport);

      if (mounted) _showSuccessDialogAndNavigate();
    } catch (e) {
      if (mounted) _showErrorSnackBar('Hata: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialogAndNavigate() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        // Custom içerik yapısı
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // İkon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, size: 56, color: Colors.green),
            ),
            const SizedBox(height: 24),
            // Başlık
            const Text(
              'Rapor Gönderildi',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),
            // Açıklama
            const Text(
              'Analiz raporu başarıyla işlendi, ilgili kişilere e-posta atıldı ve Google Drive\'a yedeklendi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 32),

            // --- BUTONLAR (Dikey ve Geniş) ---

            // 1. Ana Aksiyon: Ana Sayfaya Dön
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/home');
                },
                style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Ana Sayfaya Dön', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 12),

            // 2. İkincil Aksiyon: Geçmişi Gör
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/history');
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
                child: const Text('Geçmişi Görüntüle'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final riskColor = _getRiskColor(widget.analysis.riskLevel, isDark);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. HEADER
          SliverAppBar(
            pinned: true,
            title: Text(
              'Rapor Önizleme',
              style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            ),
            centerTitle: false,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: colorScheme.surfaceTint,
            iconTheme: IconThemeData(color: colorScheme.onSurface),
            actions: [
              IconButton(icon: const Icon(Icons.help_outline_rounded), onPressed: () => _showHelpDialog(context)),
            ],
          ),

          // 2. İÇERİK
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // FOTOĞRAF KARTI
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colorScheme.surfaceContainerHighest,
                      image: DecorationImage(image: FileImage(File(widget.imagePath)), fit: BoxFit.cover),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          const Icon(Icons.camera_alt, color: Colors.white70, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now()),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // RİSK SEVİYESİ
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: riskColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: riskColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: riskColor.withOpacity(0.2), shape: BoxShape.circle),
                          child: Icon(_getRiskIcon(widget.analysis.riskLevel), color: riskColor, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Risk Seviyesi',
                              style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                            ),
                            Text(
                              widget.analysis.riskLevel.toUpperCase(),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: riskColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // FORM ALANLARI
                  _SectionHeader(title: 'Rapor İçeriği'),

                  _buildModernTextField(
                    context: context,
                    controller: _subjectController,
                    label: 'E-posta Konusu',
                    icon: Icons.title_rounded,
                    maxLines: 1,
                  ),

                  const SizedBox(height: 16),

                  _buildModernTextField(
                    context: context,
                    controller: _finalMessageController,
                    label: 'Analiz ve Açıklama',
                    icon: Icons.description_outlined,
                    maxLines: 6,
                    hint: 'AI analiz sonucunu buradan düzenleyebilirsiniz...',
                  ),

                  const SizedBox(height: 32),

                  // ALICILAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SectionHeader(title: 'Alıcılar', padding: EdgeInsets.zero),
                      TextButton.icon(
                        onPressed: _addRecipient,
                        icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                        label: const Text('Ekle'),
                        style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
                    ),
                    child: _recipients.isEmpty
                        ? Center(
                            child: Text('Henüz alıcı eklenmedi.', style: TextStyle(color: colorScheme.outline)),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _recipients
                                .map(
                                  (email) => InputChip(
                                    label: Text(email),
                                    labelStyle: TextStyle(fontSize: 13, color: colorScheme.onSurface),
                                    backgroundColor: colorScheme.surface,
                                    side: BorderSide(color: colorScheme.outlineVariant),
                                    onDeleted: () => setState(() => _recipients.remove(email)),
                                    deleteIconColor: colorScheme.onSurfaceVariant,
                                  ),
                                )
                                .toList(),
                          ),
                  ),

                  const SizedBox(height: 24),

                  // OTOMATİK İŞLEMLER BİLGİSİ
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded, size: 20, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Rapor gönderildiğinde otomatik olarak Google Drive\'a yedeklenir.',
                            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // AKSİYON BUTONLARI
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('İptal'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        // DÜZELTİLDİ: Standard FilledButton ile Custom Child
                        child: FilledButton(
                          onPressed: _isLoading ? null : _sendReport,
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.primary, // Indigo/Mavi
                            disabledBackgroundColor: colorScheme.primary.withOpacity(0.7),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          // Loading durumunda özel içerik
                          child: _isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5, // Daha belirgin
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text('Gönderiliyor...', style: TextStyle(color: Colors.white)),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [Icon(Icons.send_rounded), SizedBox(width: 8), Text('Raporu Gönder')],
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? hint,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Icon(icon, color: colorScheme.primary),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yardım'),
        content: const Text(
          '• Analiz metnini ve e-posta konusunu düzenleyebilirsiniz.\n'
          '• "+" butonunu kullanarak yeni alıcılar ekleyebilirsiniz.\n'
          '• Rapor gönderildiğinde kopya otomatik olarak Drive\'a yüklenir.',
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry padding;

  const _SectionHeader({required this.title, this.padding = const EdgeInsets.only(left: 4, bottom: 12)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _AddRecipientDialog extends StatefulWidget {
  final List<String> existingRecipients;
  final Function(String) onAdd;

  const _AddRecipientDialog({required this.existingRecipients, required this.onAdd});

  @override
  State<_AddRecipientDialog> createState() => _AddRecipientDialogState();
}

class _AddRecipientDialogState extends State<_AddRecipientDialog> {
  final _controller = TextEditingController();
  String? _error;

  void _submit() {
    final email = _controller.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'E-posta boş olamaz');
      return;
    }
    if (!EmailTemplateGenerator.isValidEmail(email)) {
      setState(() => _error = 'Geçersiz e-posta formatı');
      return;
    }
    if (widget.existingRecipients.contains(email)) {
      setState(() => _error = 'Bu e-posta zaten ekli');
      return;
    }
    widget.onAdd(email);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alıcı Ekle'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'E-posta',
          errorText: _error,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: TextInputType.emailAddress,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        FilledButton(onPressed: _submit, child: const Text('Ekle')),
      ],
    );
  }
}
