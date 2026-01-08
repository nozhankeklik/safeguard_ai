import 'package:flutter/material.dart';
import 'package:safeguard_ai/core/constants/app_constants.dart';

/// Ayarlar Sayfası
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkModeEnabled = false;
  bool _notificationsEnabled = true;
  bool _mockModeEnabled = true; // TODO: Gerçek değer injection_container'dan gelecek

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
            icon: Icons.dark_mode_outlined,
            title: 'Karanlık Mod',
            subtitle: 'Koyu tema kullan',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() => _darkModeEnabled = value);
              // TODO: Tema değişikliği uygulanacak
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
            icon: Icons.wifi_tethering,
            title: 'Bağlantı Testi',
            subtitle: 'n8n API bağlantısını test et',
            onTap: () {
              // TODO: Bağlantı testi yapılacak
              _showComingSoonDialog('Bağlantı Testi');
            },
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
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
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
