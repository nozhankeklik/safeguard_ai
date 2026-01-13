import 'package:intl/intl.dart';

/// Date formatting utility
/// 
/// Provides consistent date formatting across the application.
class DateFormatter {
  DateFormatter._();

  /// Format date for display in reports
  static String formatReportDate(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }

  /// Format date for list items (short format)
  static String formatListDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  /// Format date for email headers
  static String formatEmailDate(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }

  /// Get relative time string (e.g., "2 hours ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }
}
