import 'package:flutter/material.dart';
import 'package:safeguard_ai/core/constants/app_constants.dart';

/// Geçmiş Raporlar Sayfası
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedFilter = 'Tümü';

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
                    onSelected: () => setState(() => _selectedFilter = 'Tümü'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Yüksek Risk',
                    isSelected: _selectedFilter == 'Yüksek Risk',
                    color: RiskColors.highRiskPrimary,
                    onSelected: () => setState(() => _selectedFilter = 'Yüksek Risk'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Orta Risk',
                    isSelected: _selectedFilter == 'Orta Risk',
                    color: RiskColors.mediumRiskPrimary,
                    onSelected: () => setState(() => _selectedFilter = 'Orta Risk'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Düşük Risk',
                    isSelected: _selectedFilter == 'Düşük Risk',
                    color: RiskColors.lowRiskPrimary,
                    onSelected: () => setState(() => _selectedFilter = 'Düşük Risk'),
                  ),
                ],
              ),
            ),
          ),

          // Liste (şimdilik boş)
          Expanded(
            child: _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  /// Boş durum gösterimi
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz rapor yok',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'İlk analizinizi yapmak için\n"Yeni Analiz" sekmesine gidin',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
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

/// Filtre chip widget'ı
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Theme.of(context).primaryColor;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: Colors.grey.shade100,
      selectedColor: chipColor.withOpacity(0.2),
      checkmarkColor: chipColor,
      labelStyle: TextStyle(
        color: isSelected ? chipColor : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? chipColor : Colors.grey.shade300,
        width: isSelected ? 2 : 1,
      ),
    );
  }
}
