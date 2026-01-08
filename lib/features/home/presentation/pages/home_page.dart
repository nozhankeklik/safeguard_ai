import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safeguard_ai/core/constants/app_constants.dart';
import 'package:safeguard_ai/features/analysis/data/repositories/report_local_repository.dart';

/// Ana Dashboard Sayfası
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repository = ReportLocalRepository();

  @override
  Widget build(BuildContext context) {
    final stats = _repository.getRiskLevelStatistics();
    final thisMonthCount = _repository.getThisMonthReportsCount();
    final thisWeekCount = _repository.getThisWeekReportsCount();
    final sentEmailsCount = _repository.getSentEmailsCount();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeGuard AI Dashboard'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {}); // Verileri yenile
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppConstants.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hoşgeldiniz kartı
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.spacingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '👋 Hoşgeldiniz',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                      SizedBox(height: AppConstants.spacingSmall),
                      Text(
                        'SafeGuard AI ile iş güvenliğinizi yapay zeka ile analiz edin.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                      SizedBox(height: AppConstants.spacingLarge),
                      ElevatedButton.icon(
                        onPressed: () => context.go('/analyze'),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Yeni Analiz Başlat'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingXLarge,
                            vertical: AppConstants.spacingMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppConstants.spacingXLarge),

              // İstatistikler başlığı
              Text(
                'İstatistikler',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              SizedBox(height: AppConstants.spacingMedium),

              // Risk seviyesi istatistikleri
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Yüksek Risk',
                      value: stats['YÜKSEK']?.toString() ?? '0',
                      color: RiskColors.highRiskPrimary,
                      icon: Icons.warning,
                    ),
                  ),
                  SizedBox(width: AppConstants.spacingMedium),
                  Expanded(
                    child: _StatCard(
                      title: 'Orta Risk',
                      value: stats['ORTA']?.toString() ?? '0',
                      color: RiskColors.mediumRiskPrimary,
                      icon: Icons.info,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppConstants.spacingMedium),

              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Düşük Risk',
                      value: stats['DÜŞÜK']?.toString() ?? '0',
                      color: RiskColors.lowRiskPrimary,
                      icon: Icons.check_circle,
                    ),
                  ),
                  SizedBox(width: AppConstants.spacingMedium),
                  Expanded(
                    child: _StatCard(
                      title: 'Toplam',
                      value: ((stats['YÜKSEK'] ?? 0) + (stats['ORTA'] ?? 0) + (stats['DÜŞÜK'] ?? 0)).toString(),
                      color: Colors.deepPurpleAccent,
                      icon: Icons.folder,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppConstants.spacingXLarge),

              // Aktivite istatistikleri
              Text(
                'Aktivite',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              SizedBox(height: AppConstants.spacingMedium),

              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.spacingMedium),
                  child: Column(
                    children: [
                      _ActivityTile(
                        icon: Icons.calendar_today,
                        title: 'Bu Hafta',
                        value: '$thisWeekCount rapor',
                      ),
                      Divider(height: AppConstants.spacingLarge),
                      _ActivityTile(
                        icon: Icons.calendar_month,
                        title: 'Bu Ay',
                        value: '$thisMonthCount rapor',
                      ),
                      Divider(height: AppConstants.spacingLarge),
                      _ActivityTile(
                        icon: Icons.email,
                        title: 'Gönderilen Email',
                        value: '$sentEmailsCount adet',
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppConstants.spacingXLarge),

              // Hızlı Erişim
              Text(
                'Hızlı Erişim',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              SizedBox(height: AppConstants.spacingMedium),

              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.history, color: Colors.blue),
                      title: const Text('Geçmiş Raporlar'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => context.go('/history'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.settings, color: Colors.grey),
                      title: const Text('Ayarlar'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => context.go('/settings'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// İstatistik kartı widget'ı
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.elevationMedium,
      child: Padding(
        padding: EdgeInsets.all(AppConstants.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
            SizedBox(height: AppConstants.spacingSmall),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Aktivite listesi item'ı
class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppConstants.spacingSmall),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          ),
          child: Icon(icon, size: 20, color: Colors.grey.shade700),
        ),
        SizedBox(width: AppConstants.spacingMedium),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
