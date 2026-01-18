import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../analysis/data/repositories/report_local_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repository = ReportLocalRepository();

  @override
  Widget build(BuildContext context) {
    // Tema verilerini al
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Verileri çek
    final stats = _repository.getRiskLevelStatistics();
    final thisMonthCount = _repository.getThisMonthReportsCount();
    final thisWeekCount = _repository.getThisWeekReportsCount();
    final sentEmailsCount = _repository.getSentEmailsCount();
    final totalReports = (stats['YÜKSEK'] ?? 0) + (stats['ORTA'] ?? 0) + (stats['DÜŞÜK'] ?? 0);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. HEADER (Düzeltildi: Large kaldırıldı, Standart yükseklik)
            SliverAppBar(
              pinned: true, // Aşağı kaydırınca sabit kalsın
              floating: true,
              title: Text(
                'SafeGuard AI',
                style: TextStyle(
                  fontWeight: FontWeight.w700, // Biraz daha kalın
                  color: colorScheme.onSurface, // Siyah/Gri (Standart)
                  fontSize: 20,
                ),
              ),
              centerTitle: false,
              backgroundColor: colorScheme.surface,
              surfaceTintColor: Colors.transparent, // Renk değişimini engelle
              actions: [
                IconButton(
                  onPressed: () => context.go('/settings'),
                  icon: Icon(Icons.settings_outlined, color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(width: 8),
              ],
            ),

            // 2. İÇERİK
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16), // Header ile içerik arası mesafe
                    // 3. HERO KART (Analiz Başlat)
                    _buildHeroActionCard(context, colorScheme, theme.textTheme, isDark),

                    const SizedBox(height: 24),

                    // 4. İSTATİSTİKLER
                    Text(
                      'Genel Bakış',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _DashboardStatCard(
                            label: 'Yüksek Risk',
                            value: stats['YÜKSEK']?.toString() ?? '0',
                            icon: Icons.warning_amber_rounded,
                            baseColor: colorScheme.error,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DashboardStatCard(
                            label: 'Orta Risk',
                            value: stats['ORTA']?.toString() ?? '0',
                            icon: Icons.report_gmailerrorred_rounded,
                            baseColor: isDark ? Colors.orangeAccent : Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _DashboardStatCard(
                            label: 'Düşük Risk',
                            value: stats['DÜŞÜK']?.toString() ?? '0',
                            icon: Icons.check_circle_outline_rounded,
                            baseColor: isDark ? Colors.greenAccent : Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DashboardStatCard(
                            label: 'Toplam Analiz',
                            value: totalReports.toString(),
                            icon: Icons.folder_open_rounded,
                            baseColor: colorScheme.primary,
                            isNeutral: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 5. AKTİVİTE ÖZETİ (Card yapısı AppTheme ile uyumlu hale getirildi)
                    Text(
                      'Aktivite Özeti',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Card(
                      child: Column(
                        children: [
                          _ActivityRow(
                            icon: Icons.calendar_view_week_rounded,
                            label: 'Bu Hafta',
                            value: '$thisWeekCount Rapor',
                            iconColor: colorScheme.primary,
                          ),
                          Divider(
                            height: 1,
                            indent: 56,
                            endIndent: 16,
                            color: colorScheme.outlineVariant.withOpacity(0.2),
                          ),
                          _ActivityRow(
                            icon: Icons.calendar_month_rounded,
                            label: 'Bu Ay',
                            value: '$thisMonthCount Rapor',
                            iconColor: colorScheme.primary,
                          ),
                          Divider(
                            height: 1,
                            indent: 56,
                            endIndent: 16,
                            color: colorScheme.outlineVariant.withOpacity(0.2),
                          ),
                          _ActivityRow(
                            icon: Icons.mark_email_read_rounded,
                            label: 'Bildirimler',
                            value: '$sentEmailsCount Gönderildi',
                            iconColor: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 6. HIZLI ERİŞİM
                    Card(
                      child: ListTile(
                        onTap: () => context.go('/history'),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.history_rounded, color: colorScheme.primary),
                        ),
                        title: const Text('Geçmiş Raporlar', style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: const Text('Tüm analiz geçmişini görüntüle', style: TextStyle(fontSize: 12)),
                        trailing: Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroActionCard(BuildContext context, ColorScheme colorScheme, TextTheme textTheme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.primary, // Indigo/Mavi zemin
        borderRadius: BorderRadius.circular(20), // AppTheme ile uyumlu radius
        boxShadow: [BoxShadow(color: colorScheme.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.auto_awesome, color: colorScheme.onPrimary, size: 28),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('AI Destekli', style: textTheme.labelSmall?.copyWith(color: colorScheme.onPrimary)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Yeni Bir Analiz Başlat',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ortamı tarayarak potansiyel riskleri tespit edin.',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary.withOpacity(0.8)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/analyze'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.onPrimary,
                foregroundColor: colorScheme.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Analiz Başlat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color baseColor;
  final bool isNeutral;

  const _DashboardStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.baseColor,
    this.isNeutral = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final containerColor = isNeutral
        ? theme.colorScheme.surface
        : baseColor.withOpacity(isDark ? 0.15 : 0.05); // Daha hafif zemin

    final contentColor = isNeutral ? theme.colorScheme.primary : baseColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // Neutral ise gri kenarlık, değilse renkli kenarlık
          color: isNeutral ? theme.colorScheme.outlineVariant.withOpacity(0.3) : baseColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: contentColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: contentColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: isNeutral ? theme.colorScheme.onSurface : contentColor,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _ActivityRow({required this.icon, required this.label, required this.value, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
