import 'package:flutter/material.dart';
import 'package:safeguard_ai/core/services/default_recipients_service.dart';
import 'package:safeguard_ai/core/utils/email_template_generator.dart';

/// Önceden Tanımlı Alıcılar Sayfası - Modern & Uyumlu Tasarım
class PredefinedRecipientsPage extends StatefulWidget {
  const PredefinedRecipientsPage({super.key});

  @override
  State<PredefinedRecipientsPage> createState() => _PredefinedRecipientsPageState();
}

class _PredefinedRecipientsPageState extends State<PredefinedRecipientsPage> {
  List<String> _lowRiskRecipients = [];
  List<String> _mediumRiskRecipients = [];
  List<String> _highRiskRecipients = [];
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadRecipients();
  }

  Future<void> _loadRecipients() async {
    setState(() => _isLoading = true);
    try {
      final low = await DefaultRecipientsService.getLowRiskRecipients();
      final medium = await DefaultRecipientsService.getMediumRiskRecipients();
      final high = await DefaultRecipientsService.getHighRiskRecipients();

      if (mounted) {
        setState(() {
          _lowRiskRecipients = low;
          _mediumRiskRecipients = medium;
          _highRiskRecipients = high;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Hata: $e');
      }
    }
  }

  Future<void> _saveRecipients() async {
    setState(() => _isSaving = true);
    try {
      await DefaultRecipientsService.saveLowRiskRecipients(_lowRiskRecipients);
      await DefaultRecipientsService.saveMediumRiskRecipients(_mediumRiskRecipients);
      await DefaultRecipientsService.saveHighRiskRecipients(_highRiskRecipients);

      if (mounted) {
        _showSuccessSnackBar('Değişiklikler kaydedildi');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Kaydetme hatası: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _resetToDefaults() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.restore_page_rounded, size: 48),
        title: const Text('Varsayılanlara Dön?'),
        content: const Text('Tüm özel alıcı listeleri silinecek ve varsayılan ayarlara dönülecek.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Vazgeç')),
          FilledButton.tonal(onPressed: () => Navigator.pop(context, true), child: const Text('Sıfırla')),
        ],
      ),
    );

    if (confirmed == true) {
      await DefaultRecipientsService.resetToDefaults();
      await _loadRecipients();
      if (mounted) {
        _showSuccessSnackBar('Varsayılanlara dönüldü');
      }
    }
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. HEADER (DÜZELTİLDİ: Large kaldırıldı, Standart yapıldı)
                SliverAppBar(
                  pinned: true,
                  title: Text(
                    'Alıcı Yönetimi',
                    // Başlık rengi diğer sayfalarla (Siyah/Gri) eşitlendi
                    style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                  ),
                  centerTitle: false,
                  backgroundColor: colorScheme.surface,
                  surfaceTintColor: colorScheme.surfaceTint,
                  iconTheme: IconThemeData(color: colorScheme.onSurface), // Geri butonu rengi
                  actions: [
                    IconButton(
                      icon: Icon(Icons.refresh_rounded, color: colorScheme.onSurfaceVariant),
                      onPressed: _loadRecipients,
                      tooltip: 'Yenile',
                    ),
                    IconButton(
                      icon: Icon(Icons.restore_rounded, color: colorScheme.onSurfaceVariant),
                      onPressed: _resetToDefaults,
                      tooltip: 'Varsayılanlara Sıfırla',
                    ),
                    const SizedBox(width: 8),
                  ],
                ),

                // 2. İÇERİK
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8), // Header altı hafif boşluk
                        // BİLGİLENDİRME KARTI
                        Card(
                          elevation: 0,
                          color: colorScheme.primaryContainer.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.2)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline_rounded, color: colorScheme.primary),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Risk seviyelerine göre otomatik e-posta gönderilecek kişileri buradan yönetebilirsiniz.',
                                    style: TextStyle(
                                      color: colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // KUTUCUKLAR (Card yapısı SettingsPage ile eşitlendi)

                        // Düşük Risk
                        _RiskLevelSection(
                          title: 'Düşük Risk Alıcıları',
                          icon: Icons.check_circle_outline_rounded,
                          color: isDark ? Colors.greenAccent : Colors.green.shade700,
                          containerColor: isDark ? Colors.green.withOpacity(0.1) : Colors.green.shade50,
                          recipients: _lowRiskRecipients,
                          onRecipientsChanged: (recipients) {
                            setState(() => _lowRiskRecipients = recipients);
                          },
                        ),
                        const SizedBox(height: 16),

                        // Orta Risk
                        _RiskLevelSection(
                          title: 'Orta Risk Alıcıları',
                          icon: Icons.warning_amber_rounded,
                          color: isDark ? Colors.orangeAccent : Colors.orange.shade800,
                          containerColor: isDark ? Colors.orange.withOpacity(0.1) : Colors.orange.shade50,
                          recipients: _mediumRiskRecipients,
                          onRecipientsChanged: (recipients) {
                            setState(() => _mediumRiskRecipients = recipients);
                          },
                        ),
                        const SizedBox(height: 16),

                        // Yüksek Risk
                        _RiskLevelSection(
                          title: 'Yüksek Risk Alıcıları',
                          icon: Icons.dangerous_outlined,
                          color: colorScheme.error,
                          containerColor: colorScheme.errorContainer.withOpacity(0.3),
                          recipients: _highRiskRecipients,
                          onRecipientsChanged: (recipients) {
                            setState(() => _highRiskRecipients = recipients);
                          },
                        ),

                        const SizedBox(height: 32),

                        // KAYDET BUTONU
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton.icon(
                            onPressed: _isSaving ? null : _saveRecipients,
                            icon: _isSaving
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary),
                                  )
                                : const Icon(Icons.save_rounded),
                            label: Text(
                              _isSaving ? 'Kaydediliyor...' : 'Değişiklikleri Kaydet',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.primary, // Indigo
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

/// Risk seviyesi bölümü widget'ı
class _RiskLevelSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color containerColor;
  final List<String> recipients;
  final ValueChanged<List<String>> onRecipientsChanged;

  const _RiskLevelSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.containerColor,
    required this.recipients,
    required this.onRecipientsChanged,
  });

  Future<void> _addRecipient(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return _AddRecipientDialog(
          existingRecipients: recipients,
          onAdd: (email) {
            final updated = List<String>.from(recipients)..add(email);
            onRecipientsChanged(updated);
            Navigator.pop(dialogContext);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0, // Düz modern tasarım
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)), // İnce kenarlık
      ),
      color: colorScheme.surfaceContainerLow, // Standart kart rengi
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // İkon Kutusu
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _addRecipient(context),
                  icon: Icon(Icons.add_circle_outline_rounded, color: colorScheme.primary),
                  tooltip: 'Ekle',
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (recipients.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    'Tanımlı alıcı yok',
                    style: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: recipients.map((email) {
                  return Chip(
                    label: Text(email, style: TextStyle(fontSize: 12, color: colorScheme.onSurface)),
                    backgroundColor: colorScheme.surface,
                    side: BorderSide(color: colorScheme.outlineVariant),
                    deleteIcon: Icon(Icons.close_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                    onDeleted: () {
                      final updated = List<String>.from(recipients)..remove(email);
                      onRecipientsChanged(updated);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  );
                }).toList(),
              ),
          ],
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

    if (email.isEmpty) {
      setState(() => _errorMessage = 'Boş bırakılamaz');
      return;
    }
    if (!EmailTemplateGenerator.isValidEmail(email)) {
      setState(() => _errorMessage = 'Geçersiz e-posta');
      return;
    }
    if (widget.existingRecipients.contains(email)) {
      setState(() => _errorMessage = 'Zaten ekli');
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
        decoration: InputDecoration(
          labelText: 'E-posta Adresi',
          hintText: 'ornek@sirket.com',
          errorText: _errorMessage,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: const Icon(Icons.email_outlined),
        ),
        keyboardType: TextInputType.emailAddress,
        autofocus: true,
        onChanged: (_) {
          if (_errorMessage != null) setState(() => _errorMessage = null);
        },
        onSubmitted: (_) => _handleAdd(),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        FilledButton(onPressed: _handleAdd, child: const Text('Ekle')),
      ],
    );
  }
}
