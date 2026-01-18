import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safeguard_ai/features/analysis/data/models/report_hive_model.dart';

/// Rapor detay sayfası - Modern & Uyumlu Tasarım
class ReportDetailPage extends StatelessWidget {
  final ReportHiveModel report;

  const ReportDetailPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm');
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Risk Rengini Belirle
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

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. HEADER (DÜZELTİLDİ: Large kaldırıldı, Standart yapıldı)
          SliverAppBar(
            pinned: true,
            title: Text(
              'Rapor Detayı',
              // Başlık rengi diğer sayfalarla eşitlendi
              style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            ),
            centerTitle: false,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: colorScheme.surfaceTint,
            // Geri butonu rengi
            iconTheme: IconThemeData(color: colorScheme.onSurface),
          ),

          // 2. İÇERİK
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // --- RESİM ALANI ---
                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Köşeler daha yumuşak
                      color: colorScheme.surfaceContainerHighest,
                      image: (report.imagePath.isNotEmpty && !report.imagePath.startsWith('demo'))
                          ? DecorationImage(image: FileImage(File(report.imagePath)), fit: BoxFit.cover)
                          : null,
                    ),
                    child: (report.imagePath.isEmpty || report.imagePath.startsWith('demo'))
                        ? _buildPlaceholderImage(colorScheme)
                        : null,
                  ),

                  const SizedBox(height: 24),

                  // --- ÜST BİLGİ (Risk & Tarih) ---
                  Row(
                    children: [
                      // Risk Rozeti
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: riskColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: riskColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.analytics_rounded, size: 18, color: riskColor),
                            const SizedBox(width: 8),
                            Text(
                              report.riskLevel,
                              style: TextStyle(color: riskColor, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Tarih
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text(
                            dateFormat.format(report.timestamp),
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // --- ANALİZ SONUCU ---
                  _SectionHeader(title: 'Analiz Raporu'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow, // Modern zemin
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)), // İnce kenarlık
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.auto_awesome, color: colorScheme.primary, size: 24),
                        const SizedBox(height: 12),
                        Text(
                          report.analysis,
                          style: theme.textTheme.bodyLarge?.copyWith(height: 1.6, color: colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- İŞLEM DURUMU (Grid) ---
                  _SectionHeader(title: 'Sistem Durumu'),
                  Row(
                    children: [
                      Expanded(
                        child: _StatusCard(
                          label: 'E-posta',
                          isSuccess: report.emailSent,
                          successIcon: Icons.mark_email_read_rounded,
                          failIcon: Icons.unsubscribe_rounded,
                          baseColor: Colors.green, // Başarılı rengi
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatusCard(
                          label: 'Google Drive',
                          isSuccess: report.savedToGoogleDrive,
                          successIcon: Icons.cloud_done_rounded,
                          failIcon: Icons.cloud_off_rounded,
                          baseColor: Colors.blue, // Drive rengi
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // --- İLETİŞİM DETAYLARI ---
                  _SectionHeader(title: 'İletişim Detayları'),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        _DetailTile(
                          icon: Icons.subject_rounded,
                          label: 'Konu',
                          value: report.emailSubject,
                          isFirst: true,
                        ),
                        Divider(
                          height: 1,
                          indent: 56,
                          endIndent: 20,
                          color: colorScheme.outlineVariant.withOpacity(0.3),
                        ),
                        _DetailTile(
                          icon: Icons.people_alt_rounded,
                          label: 'Alıcılar',
                          value: report.recipients.join(', '),
                        ),
                        if (report.ccRecipients.isNotEmpty) ...[
                          Divider(
                            height: 1,
                            indent: 56,
                            endIndent: 20,
                            color: colorScheme.outlineVariant.withOpacity(0.3),
                          ),
                          _DetailTile(
                            icon: Icons.person_add_alt_1_rounded,
                            label: 'CC',
                            value: report.ccRecipients.join(', '),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.image_not_supported_outlined, size: 48, color: colorScheme.outline),
          const SizedBox(height: 8),
          Text(
            'Görüntü Yok',
            style: TextStyle(color: colorScheme.outline, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// --- YARDIMCI WIDGETLAR ---

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String label;
  final bool isSuccess;
  final IconData successIcon;
  final IconData failIcon;
  final Color baseColor;

  const _StatusCard({
    required this.label,
    required this.isSuccess,
    required this.successIcon,
    required this.failIcon,
    required this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final activeColor = isSuccess ? baseColor : colorScheme.error;

    // Pastel renk ayarı (Çok parlak olmaması için opacity kullanıyoruz)
    final containerColor = isSuccess ? baseColor.withOpacity(0.1) : colorScheme.errorContainer.withOpacity(0.3);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: activeColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isSuccess ? successIcon : failIcon, color: activeColor, size: 28),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            isSuccess ? 'Başarılı' : 'Başarısız',
            style: theme.textTheme.labelLarge?.copyWith(color: activeColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isFirst;

  const _DetailTile({required this.icon, required this.label, required this.value, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
