import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Reusable statistics card widget
///
/// Displays statistical information in a consistent card format
/// Used across Dashboard and other summary screens.
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;

  const StatCard({super.key, required this.title, required this.value, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: cardColor, size: 24),
                const SizedBox(width: AppConstants.spacingSmall),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: cardColor),
            ),
          ],
        ),
      ),
    );
  }
}
