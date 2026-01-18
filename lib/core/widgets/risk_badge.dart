import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Reusable risk level badge component
///
/// Displays risk level with appropriate color coding
/// and iconography for visual consistency.
class RiskBadge extends StatelessWidget {
  final String riskLevel;
  final bool isCompact;

  const RiskBadge({super.key, required this.riskLevel, this.isCompact = false});

  Color _getRiskColor(BuildContext context, String riskLevel) {
    return Theme.of(context).colorScheme.primary;
  }

  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'YÜKSEK':
      case 'HIGH':
        return Icons.dangerous;
      case 'ORTA':
      case 'MEDIUM':
        return Icons.warning_amber_rounded;
      case 'DÜŞÜK':
      case 'LOW':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingSmall, vertical: AppConstants.spacingXSmall),
      decoration: BoxDecoration(
        color: _getRiskColor(context, riskLevel),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Row(
        mainAxisSize: isCompact ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Icon(_getRiskIcon(riskLevel), color: Colors.white, size: isCompact ? 14 : 16),
          if (!isCompact) ...[
            const SizedBox(width: 4),
            Text(
              riskLevel,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
