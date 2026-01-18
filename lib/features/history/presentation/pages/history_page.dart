import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:safeguard_ai/features/analysis/data/models/report_hive_model.dart';
import 'package:safeguard_ai/features/history/presentation/bloc/history_bloc.dart';
import 'package:safeguard_ai/features/history/presentation/bloc/history_event.dart';
import 'package:safeguard_ai/features/history/presentation/bloc/history_state.dart';

/// Geçmiş Raporlar Sayfası - Modern & Uyumlu Tasarım
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedFilter = 'Tümü';

  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(const HistoryEvent.loadReports());
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
          // 1. HEADER (DÜZELTİLDİ: Large kaldırıldı, Standart boyut)
          SliverAppBar(
            pinned: true, // Aşağı kaydırınca sabit kalsın
            title: Text(
              'Geçmiş Raporlar',
              // DÜZELTİLDİ: Başlık rengi diğer sayfalarla aynı
              style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            ),
            centerTitle: false,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: colorScheme.surfaceTint,
            actions: [
              IconButton(
                icon: Icon(Icons.search_rounded, color: colorScheme.onSurfaceVariant),
                onPressed: () {
                  // TODO: Arama özelliği
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // 2. FİLTRE ÇİPLERİ
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16), // Üst boşluk ayarlandı
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _ModernFilterChip(
                      label: 'Tümü',
                      isSelected: _selectedFilter == 'Tümü',
                      onSelected: () => _applyFilter('Tümü', null),
                    ),
                    const SizedBox(width: 8),
                    _ModernFilterChip(
                      label: 'Yüksek Risk',
                      isSelected: _selectedFilter == 'Yüksek Risk',
                      color: colorScheme.error,
                      onSelected: () => _applyFilter('Yüksek Risk', 'YÜKSEK'),
                    ),
                    const SizedBox(width: 8),
                    _ModernFilterChip(
                      label: 'Orta Risk',
                      isSelected: _selectedFilter == 'Orta Risk',
                      color: Colors.orange,
                      onSelected: () => _applyFilter('Orta Risk', 'ORTA'),
                    ),
                    const SizedBox(width: 8),
                    _ModernFilterChip(
                      label: 'Düşük Risk',
                      isSelected: _selectedFilter == 'Düşük Risk',
                      color: Colors.green,
                      onSelected: () => _applyFilter('Düşük Risk', 'DÜŞÜK'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. LİSTE İÇERİĞİ
          BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              return state.when(
                initial: () => const SliverFillRemaining(child: SizedBox.shrink()),
                loading: () => SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
                ),
                loaded: (reports, currentFilter) => SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _ReportCard(report: reports[index]),
                      ),
                      childCount: reports.length,
                    ),
                  ),
                ),
                empty: () => SliverFillRemaining(child: _buildEmptyState(context)),
                failure: (message) => SliverFillRemaining(child: _buildErrorState(context, message)),
              );
            },
          ),
        ],
      ),
    );
  }

  void _applyFilter(String label, String? riskLevel) {
    setState(() => _selectedFilter = label);
    context.read<HistoryBloc>().add(HistoryEvent.filterByRiskLevel(riskLevel));
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.folder_open_rounded, size: 64, color: colorScheme.secondary),
            ),
            const SizedBox(height: 24),
            Text(
              'Henüz Rapor Bulunamadı',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Geçmiş analizlerinizi burada görebilirsiniz.\nYeni bir analiz başlatarak başlayın.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.go('/analyze'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Yeni Analiz'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modern Rapor Kartı
class _ReportCard extends StatelessWidget {
  final ReportHiveModel report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Risk Rengi Belirleme
    Color riskColor;
    switch (report.riskLevel.toUpperCase()) {
      case 'YÜKSEK':
        riskColor = colorScheme.error;
        break;
      case 'ORTA':
        riskColor = isDark ? Colors.orangeAccent : Colors.orange.shade800;
        break;
      default:
        riskColor = isDark ? Colors.greenAccent : Colors.green.shade700;
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow, // Modern kart arka planı
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/report-detail', extra: {'report': report}),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. GÖRSEL (THUMBNAIL)
                Hero(
                  tag: 'report_img_${report.id}',
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: colorScheme.surfaceContainerHighest,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: (report.imagePath.isNotEmpty && !report.imagePath.startsWith('demo'))
                          ? Image.file(
                              File(report.imagePath),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildPlaceholderIcon(colorScheme),
                            )
                          : _buildPlaceholderIcon(colorScheme),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // 2. DETAYLAR
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Başlık ve Tarih
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Risk Rozeti
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: riskColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              report.riskLevel,
                              style: TextStyle(color: riskColor, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                          // Tarih
                          Text(
                            dateFormat.format(report.timestamp),
                            style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Analiz Özeti
                      Text(
                        report.analysis,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface, height: 1.3),
                      ),

                      const SizedBox(height: 12),

                      // Durum İkonları ve Silme Butonu
                      Row(
                        children: [
                          _StatusIcon(
                            icon: Icons.mark_email_read_rounded,
                            isActive: report.emailSent,
                            activeColor: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          _StatusIcon(
                            icon: Icons.cloud_done_rounded,
                            isActive: report.savedToGoogleDrive,
                            activeColor: Colors.blue,
                          ),
                          const Spacer(),
                          // Silme Butonu
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                size: 20,
                                color: colorScheme.error.withOpacity(0.7),
                              ),
                              onPressed: () => _showDeleteDialog(context, report.id),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon(ColorScheme colorScheme) {
    return Center(
      child: Icon(Icons.image_not_supported_outlined, color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
    );
  }

  void _showDeleteDialog(BuildContext context, String reportId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Raporu Sil'),
        content: const Text('Bu işlem geri alınamaz. Devam etmek istiyor musunuz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          FilledButton.tonal(
            onPressed: () {
              context.read<HistoryBloc>().add(HistoryEvent.deleteReport(reportId));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Rapor silindi'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                  width: 200,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final Color activeColor;

  const _StatusIcon({required this.icon, required this.isActive, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    if (!isActive) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: activeColor.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(icon, size: 14, color: activeColor),
    );
  }
}

class _ModernFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final Color? color;

  const _ModernFilterChip({required this.label, required this.isSelected, required this.onSelected, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Aktif renk belirleme
    final activeColor = color ?? colorScheme.primary;
    final backgroundColor = isSelected
        ? activeColor.withOpacity(0.15)
        : colorScheme.surfaceContainerHighest.withOpacity(0.5);
    final borderColor = isSelected ? activeColor : Colors.transparent;
    final textColor = isSelected ? activeColor : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(color: textColor, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 13),
        ),
      ),
    );
  }
}
