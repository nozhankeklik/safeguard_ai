import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:safeguard_ai/core/constants/app_constants.dart';
import 'package:safeguard_ai/core/init/injection_container.dart' as di;
import 'package:safeguard_ai/main.dart' show themeNotifier;

/// Ayarlar Sayfası
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _mockModeEnabled = true; // TODO: Gerçek değer injection_container'dan gelecek
  bool _isTestingConnection = false;

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
      appBar: AppBar(
        title: const Text('Ayarlar'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Email Yönetimi Bölümü
          _SectionHeader(title: 'Email Yönetimi'),
          _SettingsTile(
            icon: Icons.email_outlined,
            title: 'Önceden Tanımlı Alıcılar',
            subtitle: 'Risk seviyelerine göre email grupları',
            onTap: () {
              // TODO: Email yönetimi sayfasına git
              _showComingSoonDialog('Email Yönetimi');
            },
          ),
          _SettingsTile(
            icon: Icons.group_outlined,
            title: 'Yüksek Risk Alıcıları',
            subtitle: '3 alıcı tanımlı', // TODO: Gerçek sayı gelecek
            onTap: () {
              _showComingSoonDialog('Yüksek Risk Alıcıları');
            },
          ),
          _SettingsTile(
            icon: Icons.warning_amber_outlined,
            title: 'Orta Risk Alıcıları',
            subtitle: '2 alıcı tanımlı', // TODO: Gerçek sayı gelecek
            onTap: () {
              _showComingSoonDialog('Orta Risk Alıcıları');
            },
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'Düşük Risk Alıcıları',
            subtitle: '1 alıcı tanımlı', // TODO: Gerçek sayı gelecek
            onTap: () {
              _showComingSoonDialog('Düşük Risk Alıcıları');
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
              _showSuccessSnackBar(
                '${themeNotifier.isDarkMode ? "🌙 Karanlık" : "☀️ Açık"} tema aktif!',
              );
            },
          ),
          _SettingsSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Bildirimler',
            subtitle: 'Push bildirimler açık',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              // TODO: Bildirim ayarları kaydedilecek
            },
          ),

          const Divider(height: 32),

          // n8n Bağlantı Durumu
          _SectionHeader(title: 'Backend Bağlantısı'),
          _SettingsSwitchTile(
            icon: _mockModeEnabled ? Icons.code : Icons.cloud_done,
            title: _mockModeEnabled ? '🎭 Mock Mode Aktif' : '🚀 Production Mode',
            subtitle: _mockModeEnabled
                ? 'Sahte veri kullanılıyor (n8n bağlantısı yok)'
                : 'n8n API kullanılıyor',
            value: _mockModeEnabled,
            onChanged: (value) {
              _showMockModeWarningDialog(value);
            },
          ),
          _SettingsTile(
            icon: _isTestingConnection ? Icons.sync : Icons.wifi_tethering,
            title: 'Bağlantı Testi',
            subtitle: _isTestingConnection 
                ? 'Test ediliyor...'
                : 'n8n API bağlantısını test et',
            trailing: _isTestingConnection 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            onTap: _isTestingConnection ? null : _testConnection,
          ),

          const Divider(height: 32),

          // Hakkında
          _SectionHeader(title: 'Hakkında'),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'Uygulama Bilgisi',
            subtitle: 'Versiyon 1.0.0',
            onTap: () {
              _showAboutDialog();
            },
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Lisans',
            subtitle: 'Açık kaynak lisansları',
            onTap: () {
              showLicensePage(context: context);
            },
          ),
          _SettingsTile(
            icon: Icons.help_outline,
            title: 'Yardım & Destek',
            subtitle: 'Dokümantasyon ve SSS',
            onTap: () {
              _showComingSoonDialog('Yardım & Destek');
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Mock mode değişikliği uyarısı
  void _showMockModeWarningDialog(bool newValue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              newValue ? Icons.code : Icons.cloud_done,
              color: newValue ? Colors.orange : Colors.green,
            ),
            const SizedBox(width: 8),
            const Text('Mod Değişikliği'),
          ],
        ),
        content: Text(
          newValue
              ? 'Mock Mode\'a geçmek istediğinize emin misiniz?\n\n'
                  'Bu modda:\n'
                  '• Sahte veri kullanılır\n'
                  '• n8n\'e bağlanılmaz\n'
                  '• Mail gönderilmez\n\n'
                  'Değişikliği yapmak için uygulamayı yeniden başlatmanız gerekir.'
              : 'Production Mode\'a geçmek istediğinize emin misiniz?\n\n'
                  'Bu modda:\n'
                  '• Gerçek n8n API kullanılır\n'
                  '• Mailler gerçekten gönderilir\n'
                  '• n8n workflow\'unun hazır olması gerekir\n\n'
                  'Değişikliği yapmak için uygulamayı yeniden başlatmanız gerekir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: injection_container.dart'taki _useMockData değerini değiştir
              _showRestartRequiredDialog();
            },
            child: const Text('Değiştir'),
          ),
        ],
      ),
    );
  }

  /// Yeniden başlatma gerekli uyarısı
  void _showRestartRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeniden Başlatma Gerekli'),
        content: const Text(
          'Değişikliğin uygulanması için uygulamayı kapatıp yeniden başlatın.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  /// Hakkında dialogu
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'SafeGuard AI',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.security, size: 48),
      children: [
        const Text(
          'AI destekli iş güvenliği analiz ve raporlama uygulaması.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Geliştirici: SafeGuard Team\n'
          'Powered by Google Gemini & n8n',
        ),
      ],
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
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
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

  /// Yakında geliyor dialogu
  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.construction, color: Colors.orange),
            SizedBox(width: 8),
            Text('Yakında Geliyor'),
          ],
        ),
        content: Text(
          '"$feature" özelliği yakında eklenecek!\n\n'
          'Şimdilik Mock Mode ile tüm özellikleri test edebilirsiniz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
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
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
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

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

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
