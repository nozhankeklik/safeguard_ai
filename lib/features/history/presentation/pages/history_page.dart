import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:safeguard_ai/core/constants/app_constants.dart';
import 'package:safeguard_ai/features/analysis/data/models/report_hive_model.dart';
import 'package:safeguard_ai/features/history/presentation/bloc/history_bloc.dart';
import 'package:safeguard_ai/features/history/presentation/bloc/history_event.dart';
import 'package:safeguard_ai/features/history/presentation/bloc/history_state.dart';

/// Geçmiş Raporlar Sayfası
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
    // Sayfa yüklendiğinde raporları getir
    context.read<HistoryBloc>().add(const HistoryEvent.loadReports());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geçmiş Raporlar'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Arama özelliği eklenecek
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtre Chips
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLarge,
              vertical: AppConstants.spacingSmall,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'Tümü',
                    isSelected: _selectedFilter == 'Tümü',
                    onSelected: () {
                      setState(() => _selectedFilter = 'Tümü');
                      context.read<HistoryBloc>().add(const HistoryEvent.filterByRiskLevel(null));
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Yüksek Risk',
                    isSelected: _selectedFilter == 'Yüksek Risk',
                    color: RiskColors.highRiskPrimary,
                    onSelected: () {
                      setState(() => _selectedFilter = 'Yüksek Risk');
                      context.read<HistoryBloc>().add(const HistoryEvent.filterByRiskLevel('YÜKSEK'));
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Orta Risk',
                    isSelected: _selectedFilter == 'Orta Risk',
                    color: RiskColors.mediumRiskPrimary,
                    onSelected: () {
                      setState(() => _selectedFilter = 'Orta Risk');
                      context.read<HistoryBloc>().add(const HistoryEvent.filterByRiskLevel('ORTA'));
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Düşük Risk',
                    isSelected: _selectedFilter == 'Düşük Risk',
                    color: RiskColors.lowRiskPrimary,
                    onSelected: () {
                      setState(() => _selectedFilter = 'Düşük Risk');
                      context.read<HistoryBloc>().add(const HistoryEvent.filterByRiskLevel('DÜŞÜK'));
                    },
                  ),
                ],
              ),
            ),
          ),

          // Liste
          Expanded(
            child: BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const Center(child: Text('Başlatılıyor...')),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  loaded: (reports, currentFilter) => _buildReportsList(reports),
                  empty: () => _buildEmptyState(),
                  failure: (message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                        const SizedBox(height: 16),
                        Text(message, style: TextStyle(color: Colors.red.shade700)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Raporlar listesi
  Widget _buildReportsList(List<ReportHiveModel> reports) {
    return ListView.builder(
      padding: EdgeInsets.all(AppConstants.spacingLarge),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return _ReportCard(report: report);
      },
    );
  }

  /// Boş durum gösterimi
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Henüz rapor yok',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'İlk analizinizi yapmak için\n"Yeni Analiz" sekmesine gidin',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Ana shell'deki index'i değiştir
              // TODO: Navigation ile çöz
            },
            icon: const Icon(Icons.add),
            label: const Text('Yeni Analiz Yap'),
          ),
        ],
      ),
    );
  }
}

/// Rapor kartı
class _ReportCard extends StatelessWidget {
  final ReportHiveModel report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final riskColor = _getRiskColor(report.riskLevel);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Card(
      margin: EdgeInsets.only(bottom: AppConstants.spacingMedium),
      child: InkWell(
        onTap: () {
          context.push(
            '/report-detail',
            extra: {'report': report},
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: EdgeInsets.all(AppConstants.spacingMedium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resim thumbnail (eğer varsa)
              if (report.imagePath.isNotEmpty && !report.imagePath.startsWith('demo'))
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  child: Image.file(
                    File(report.imagePath),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage();
                    },
                  ),
                )
              else
                _buildPlaceholderImage(),

              SizedBox(width: AppConstants.spacingMedium),

              // Detaylar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Risk badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingSmall,
                        vertical: AppConstants.spacingXSmall,
                      ),
                      decoration: BoxDecoration(
                        color: riskColor,
                        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: Text(
                        report.riskLevel,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),

                    SizedBox(height: AppConstants.spacingSmall),

                    // Analiz metni (kısaltılmış)
                    Text(
                      report.analysis,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    SizedBox(height: AppConstants.spacingSmall),

                    // Tarih ve durum ikonları
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(report.timestamp),
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        const Spacer(),
                        if (report.emailSent) Icon(Icons.email, size: 16, color: Colors.green.shade600),
                        if (report.savedToGoogleDocs)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.cloud_done, size: 16, color: Colors.blue.shade600),
                          ),
                        if (report.pdfGenerated)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.picture_as_pdf, size: 16, color: Colors.red.shade600),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Sil butonu
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.grey),
                onPressed: () {
                  _showDeleteDialog(context, report.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Icon(Icons.image, size: 40, color: Colors.grey.shade400),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'YÜKSEK':
        return RiskColors.highRiskPrimary;
      case 'ORTA':
        return RiskColors.mediumRiskPrimary;
      case 'DÜŞÜK':
        return RiskColors.lowRiskPrimary;
      default:
        return RiskColors.defaultPrimary;
    }
  }

  void _showDeleteDialog(BuildContext context, String reportId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Raporu Sil'),
        content: const Text('Bu raporu silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('İptal')),
          TextButton(
            onPressed: () {
              context.read<HistoryBloc>().add(HistoryEvent.deleteReport(reportId));
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rapor silindi')));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}

/// Filtre chip widget'ı
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onSelected;

  const _FilterChip({required this.label, required this.isSelected, this.color, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // "Tümü" chip'i için özel renk (hem açık hem koyu temada belirgin)
    final effectiveColor = color == null
        ? (isDark ? Colors.blue.shade400 : chipColor) // Koyu temada daha açık mavi
        : chipColor;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
      selectedColor: isDark
          ? effectiveColor.withOpacity(0.7) // Koyu temada çok daha belirgin
          : effectiveColor.withOpacity(0.2),
      checkmarkColor: effectiveColor,
      labelStyle: TextStyle(
        color: isSelected
            ? (isDark ? Colors.white : effectiveColor) // Koyu temada beyaz metin, açık temada mavi
            : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? effectiveColor : (isDark ? Colors.grey.shade600 : Colors.grey.shade300),
        width: isSelected ? 2 : 1,
      ),
    );
  }
}
