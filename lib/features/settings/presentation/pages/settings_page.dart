import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/init/injection_container.dart' as di;
import '../../../analysis/data/repositories/report_local_repository.dart';
import 'predefined_recipients_page.dart';
import '../../../../main.dart' show themeNotifier;

/// Ayarlar Sayfası - Modern & Uyumlu Tasarım
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
    themeNotifier.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    themeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. HEADER (DÜZELTİLDİ: Large kaldırıldı, Standart yapıldı)
          SliverAppBar(
            pinned: true,
            title: Text(
              'Ayarlar',
              // DÜZELTİLDİ: Başlık rengi standartlaştırıldı (Siyah/Gri)
              style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            ),
            centerTitle: false,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: colorScheme.surfaceTint,
          ),

          // 2. İÇERİK
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // --- İLETİŞİM ---
                  _SectionHeader(title: 'İletişim'),
                  Card(
                    elevation: 0, // Gölge kaldırıldı (Modern Flat)
                    color: colorScheme.surfaceContainerLow, // Yumuşak zemin
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)), // İnce kenarlık
                    ),
                    child: Column(
                      children: [
                        _SettingsListTile(
                          icon: Icons.mark_email_unread_rounded,
                          title: 'E-posta Alıcıları',
                          subtitle: 'Raporların gönderileceği kişileri yönet',
                          iconColor: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PredefinedRecipientsPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- GÖRÜNÜM ---
                  _SectionHeader(title: 'Görünüm'),
                  Card(
                    elevation: 0,
                    color: colorScheme.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        _SettingsSwitchTile(
                          icon: themeNotifier.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          title: 'Karanlık Mod',
                          subtitle: themeNotifier.isDarkMode ? 'Koyu tema aktif' : 'Açık tema aktif',
                          iconColor: Colors.purple,
                          value: themeNotifier.isDarkMode,
                          onChanged: (value) async {
                            await themeNotifier.toggleTheme();
                            if (mounted) setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- SİSTEM ---
                  _SectionHeader(title: 'Sistem & Bağlantı'),
                  Card(
                    elevation: 0,
                    color: colorScheme.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        _SettingsListTile(
                          icon: _isTestingConnection ? Icons.sync_rounded : Icons.hub_rounded,
                          title: 'Sunucu Bağlantısı',
                          subtitle: _isTestingConnection ? 'Kontrol ediliyor...' : 'API durumunu test et',
                          iconColor: Colors.teal,
                          trailing: _isTestingConnection
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.primary),
                                )
                              : null,
                          onTap: _isTestingConnection ? null : _testConnection,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- VERİ YÖNETİMİ ---
                  _SectionHeader(title: 'Veri Yönetimi'),
                  Card(
                    elevation: 0,
                    color: colorScheme.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        _SettingsListTile(
                          icon: Icons.delete_forever_rounded,
                          title: 'Geçmişi Temizle',
                          subtitle: 'Cihazdaki tüm raporları kalıcı olarak sil',
                          iconColor: colorScheme.error,
                          textColor: colorScheme.error,
                          onTap: _showClearDataDialog,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- VERSİYON ---
                  Center(
                    child: Text(
                      'SafeGuard AI v1.0.0',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
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

  // --- MANTIK ---

  Future<void> _testConnection() async {
    setState(() => _isTestingConnection = true);
    try {
      final dio = di.sl<Dio>();
      final response = await dio.get('/', options: Options(sendTimeout: const Duration(seconds: 5)));
      if (mounted) _showSnackBar('✅ Bağlantı Başarılı! (${response.statusCode})', Colors.green);
    } catch (e) {
      if (mounted) _showSnackBar('❌ Bağlantı Kurulamadı', Colors.red);
    } finally {
      if (mounted) setState(() => _isTestingConnection = false);
    }
  }

  void _showClearDataDialog() {
    final reportCount = _reportRepository.getAllReports().length;
    if (reportCount == 0) {
      _showSnackBar('Silinecek veri yok', Colors.grey);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emin misiniz?'),
        content: Text('Toplam $reportCount rapor silinecek. Bu işlem geri alınamaz.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _reportRepository.deleteAllReports();
              if (mounted) {
                _showSnackBar('Geçmiş temizlendi', Colors.green);
                setState(() {});
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color, behavior: SnackBarBehavior.floating));
  }
}

// --- YARDIMCI WIDGETLAR ---

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SettingsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? textColor;

  const _SettingsListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    this.onTap,
    this.trailing,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding biraz artırıldı
      leading: Container(
        padding: const EdgeInsets.all(10), // İkon kutusu büyütüldü
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: textColor ?? Theme.of(context).colorScheme.onSurface),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
      ),
      trailing:
          trailing ?? Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
      ),
      trailing: Switch(value: value, onChanged: onChanged, activeColor: Theme.of(context).colorScheme.primary),
    );
  }
}
