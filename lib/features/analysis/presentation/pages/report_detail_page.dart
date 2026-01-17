import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safeguard_ai/core/constants/app_constants.dart';
import 'package:safeguard_ai/features/analysis/data/models/report_hive_model.dart';

/// Rapor detay sayfası - History'den seçilen raporun detayını gösterir
class ReportDetailPage extends StatelessWidget {
  final ReportHiveModel report;

  const ReportDetailPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm');
    final riskColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Rapor Detayı'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim
            if (report.imagePath.isNotEmpty && !report.imagePath.startsWith('demo'))
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                child: Image.file(
                  File(report.imagePath),
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage(context);
                  },
                ),
              )
            else
              _buildPlaceholderImage(context),

            SizedBox(height: AppConstants.spacingLarge),

            // Risk Badge
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMedium,
                    vertical: AppConstants.spacingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: riskColor,
                    borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  ),
                  child: Text(
                    report.riskLevel,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const Spacer(),
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(dateFormat.format(report.timestamp), style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              ],
            ),

            SizedBox(height: AppConstants.spacingLarge),

            // Analiz
            Text('Analiz Sonucu', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: AppConstants.spacingSmall),
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.spacingMedium),
                child: Text(report.analysis, style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),

            SizedBox(height: AppConstants.spacingLarge),

            // Email Bilgileri
            Text(
              'Email Bilgileri',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppConstants.spacingSmall),
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(context, icon: Icons.email, label: 'Konu', value: report.emailSubject),
                    Divider(height: AppConstants.spacingLarge),
                    _buildInfoRow(context, icon: Icons.people, label: 'Alıcılar', value: report.recipients.join(', ')),
                    if (report.ccRecipients.isNotEmpty) ...[
                      Divider(height: AppConstants.spacingLarge),
                      _buildInfoRow(
                        context,
                        icon: Icons.person_add,
                        label: 'CC',
                        value: report.ccRecipients.join(', '),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: AppConstants.spacingLarge),

            // Durum Bilgileri
            Text('İşlem Durumu', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: AppConstants.spacingSmall),
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.spacingMedium),
                child: Column(
                  children: [
                    _buildStatusTile(
                      context,
                      icon: Icons.email,
                      label: 'Email Gönderimi',
                      isCompleted: report.emailSent,
                    ),
                    Divider(height: AppConstants.spacingLarge),
                    _buildStatusTile(
                      context,
                      icon: Icons.cloud_done,
                      label: 'Google Drive\'a Kaydedildi',
                      isCompleted: report.savedToGoogleDrive && report.pdfGenerated,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppConstants.spacingXXLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Icon(Icons.image, size: 80, color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        SizedBox(width: AppConstants.spacingSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isCompleted,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24, color: isCompleted ? Colors.green.shade600 : Colors.grey.shade400),
        SizedBox(width: AppConstants.spacingMedium),
        Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
        Icon(
          isCompleted ? Icons.check_circle : Icons.cancel,
          color: isCompleted ? Colors.green.shade600 : Colors.grey.shade400,
        ),
      ],
    );
  }
}
