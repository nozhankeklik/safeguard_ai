import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:safeguard_ai/core/constants/app_constants.dart';
import 'package:safeguard_ai/core/init/injection_container.dart' as di;
import 'package:safeguard_ai/features/analysis/data/repositories/report_local_repository.dart';
import 'package:safeguard_ai/features/settings/presentation/pages/predefined_recipients_page.dart';
import 'package:safeguard_ai/main.dart' show themeNotifier;

/// Ayarlar Sayfası
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isTestingConnection = false;
  final _reportRepository = ReportLocalRepository();

  @override
  void initState() {
    super.initState();
    // Tema değişikliklerini dinle
    themeNotifier.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    themeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {}); // UI'ı yenile
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar'), centerTitle: true),
      body: ListView(
        children: [
          // Email Yönetimi Bölümü
          _SectionHeader(title: 'Email Yönetimi'),
          _SettingsTile(
            icon: Icons.email_outlined,
            title: 'E-posta Alıcı Yönetimi',
            subtitle: 'Risk seviyelerine göre otomatik e-posta alıcılarını yönet',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PredefinedRecipientsPage()));
            },
          ),

          const Divider(height: 32),

          // Uygulama Ayarları
          _SectionHeader(title: 'Uygulama Ayarları'),
          _SettingsSwitchTile(
            icon: themeNotifier.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            title: 'Karanlık Mod',
            subtitle: themeNotifier.isDarkMode ? 'Koyu tema aktif' : 'Açık tema aktif',
            value: themeNotifier.isDarkMode,
            onChanged: (value) async {
              await themeNotifier.toggleTheme();
              _showSuccessSnackBar('${themeNotifier.isDarkMode ? "🌙 Karanlık" : "☀️ Açık"} tema aktif!');
            },
          ),

          const Divider(height: 32),

          // Veri Yönetimi
          _SectionHeader(title: 'Veri Yönetimi'),
          _SettingsTile(
            icon: Icons.delete_sweep_outlined,
            title: 'Rapor Geçmişini Temizle',
            subtitle: 'Tüm kayıtlı raporları sil (${_reportRepository.getAllReports().length} rapor)',
            onTap: _showClearDataDialog,
          ),

          const Divider(height: 32),

          // n8n Bağlantı Durumu
          _SectionHeader(title: 'Backend Bağlantısı'),
          _SettingsTile(
            icon: _isTestingConnection ? Icons.sync : Icons.wifi_tethering,
            title: 'Bağlantı Testi',
            subtitle: _isTestingConnection ? 'Test ediliyor...' : 'n8n API bağlantısını test et',
            trailing: _isTestingConnection
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : null,
            onTap: _isTestingConnection ? null : _testConnection,
          ),

          const SizedBox(height: 32),

          // Uygulama Versiyonu (Footer)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'SafeGuard AI v1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }


  /// n8n bağlantı testi
  Future<void> _testConnection() async {
    setState(() => _isTestingConnection = true);

    try {
      final dio = di.sl<Dio>();

      // Basit bir GET request ile test
      final response = await dio.get(
        '/',
        options: Options(sendTimeout: const Duration(seconds: 5), receiveTimeout: const Duration(seconds: 5)),
      );

      if (mounted) {
        _showSuccessSnackBar('✅ Bağlantı başarılı! (Status: ${response.statusCode})');
      }
    } on DioException catch (e) {
      if (mounted) {
        if (e.type == DioExceptionType.connectionTimeout) {
          _showErrorSnackBar('❌ Bağlantı zaman aşımına uğradı');
        } else if (e.type == DioExceptionType.receiveTimeout) {
          _showErrorSnackBar('❌ Sunucu yanıt vermiyor');
        } else if (e.response?.statusCode == 404) {
          // 404 bile bağlantı var demektir
          _showSuccessSnackBar('✅ Bağlantı başarılı! (Endpoint bulunamadı ama sunucu çalışıyor)');
        } else {
          _showErrorSnackBar('❌ Bağlantı başarısız: ${e.message}');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('❌ Beklenmeyen hata: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isTestingConnection = false);
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

  /// Veri temizleme dialogu
  void _showClearDataDialog() {
    final reportCount = _reportRepository.getAllReports().length;

    if (reportCount == 0) {
      _showErrorSnackBar('Temizlenecek rapor bulunamadı');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Veri Temizleme'),
          ],
        ),
        content: Text(
          'Tüm rapor geçmişi silinecek ($reportCount rapor).\n\n'
          'Bu işlem geri alınamaz. Emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _clearAllReports();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Temizle'),
          ),
        ],
      ),
    );
  }

  /// Tüm raporları temizle
  Future<void> _clearAllReports() async {
    try {
      await _reportRepository.deleteAllReports();
      if (mounted) {
        _showSuccessSnackBar('Tüm raporlar başarıyla silindi');
        setState(() {}); // UI'ı yenile (rapor sayısını güncelle)
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Veri temizlenirken hata oluştu: $e');
      }
    }
  }

}

/// Bölüm başlığı widget'ı
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingLarge,
        AppConstants.spacingXLarge,
        AppConstants.spacingLarge,
        AppConstants.spacingSmall,
      ),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Ayar listesi öğesi
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsTile({required this.icon, required this.title, required this.subtitle, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

/// Switch'li ayar öğesi
class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}
