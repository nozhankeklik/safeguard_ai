import 'package:flutter/material.dart';
import 'package:safeguard_ai/core/services/default_recipients_service.dart';
import 'package:safeguard_ai/core/utils/email_template_generator.dart';

/// Önceden Tanımlı Alıcılar Sayfası
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

  /// Alıcıları yükle
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
        _showErrorSnackBar('Alıcılar yüklenirken hata oluştu: $e');
      }
    }
  }

  /// Alıcıları kaydet
  Future<void> _saveRecipients() async {
    setState(() => _isSaving = true);
    try {
      await DefaultRecipientsService.saveLowRiskRecipients(_lowRiskRecipients);
      await DefaultRecipientsService.saveMediumRiskRecipients(_mediumRiskRecipients);
      await DefaultRecipientsService.saveHighRiskRecipients(_highRiskRecipients);

      if (mounted) {
        _showSuccessSnackBar('Alıcılar başarıyla kaydedildi!');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Kaydetme sırasında hata oluştu: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  /// Default değerlere sıfırla
  Future<void> _resetToDefaults() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Varsayılan Değerlere Sıfırla'),
        content: const Text('Tüm alıcılar varsayılan değerlere sıfırlanacak. Emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sıfırla', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DefaultRecipientsService.resetToDefaults();
      await _loadRecipients();
      if (mounted) {
        _showSuccessSnackBar('Varsayılan değerlere sıfırlandı!');
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Önceden Tanımlı Alıcılar'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadRecipients,
            tooltip: 'Yenile',
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _isLoading ? null : _resetToDefaults,
            tooltip: 'Varsayılanlara Sıfırla',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bilgilendirme kartı
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Risk seviyelerine göre otomatik olarak gönderilecek e-posta alıcılarını buradan yönetebilirsiniz.',
                              style: TextStyle(color: Colors.blue.shade900),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Düşük Risk
                  _RiskLevelSection(
                    title: 'Düşük Risk Alıcıları',
                    icon: Icons.check_circle,
                    color: Colors.green,
                    recipients: _lowRiskRecipients,
                    onRecipientsChanged: (recipients) {
                      setState(() => _lowRiskRecipients = recipients);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Orta Risk
                  _RiskLevelSection(
                    title: 'Orta Risk Alıcıları',
                    icon: Icons.warning_amber_rounded,
                    color: Colors.orange,
                    recipients: _mediumRiskRecipients,
                    onRecipientsChanged: (recipients) {
                      setState(() => _mediumRiskRecipients = recipients);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Yüksek Risk
                  _RiskLevelSection(
                    title: 'Yüksek Risk Alıcıları',
                    icon: Icons.dangerous,
                    color: Colors.red,
                    recipients: _highRiskRecipients,
                    onRecipientsChanged: (recipients) {
                      setState(() => _highRiskRecipients = recipients);
                    },
                  ),
                  const SizedBox(height: 32),

                  // Kaydet butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _saveRecipients,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                            )
                          : const Icon(Icons.save),
                      label: Text(_isSaving ? 'Kaydediliyor...' : 'Değişiklikleri Kaydet'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}

/// Risk seviyesi bölümü widget'ı
class _RiskLevelSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> recipients;
  final ValueChanged<List<String>> onRecipientsChanged;

  const _RiskLevelSection({
    required this.title,
    required this.icon,
    required this.color,
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
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _addRecipient(context),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Ekle'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (recipients.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Henüz alıcı eklenmemiş',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: recipients.map((email) {
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  return Chip(
                    label: Text(email, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                    onDeleted: () {
                      final updated = List<String>.from(recipients)..remove(email);
                      onRecipientsChanged(updated);
                    },
                    deleteIcon: Icon(Icons.close, size: 18, color: isDark ? Colors.white70 : Colors.black54),
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
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
