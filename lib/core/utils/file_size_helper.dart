/// File size formatting utility
/// 
/// Converts file sizes to human-readable format.
class FileSizeHelper {
  FileSizeHelper._();

  /// Format bytes to human-readable string
  static String formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Check if file size exceeds limit
  static bool exceedsLimit(int bytes, int maxBytes) {
    return bytes > maxBytes;
  }

  /// Get recommended compression quality based on file size
  static int getRecommendedQuality(int bytes) {
    if (bytes > 5 * 1024 * 1024) {
      // > 5MB: Aggressive compression
      return 70;
    } else if (bytes > 2 * 1024 * 1024) {
      // > 2MB: Moderate compression
      return 85;
    } else {
      // < 2MB: Light compression
      return 95;
    }
  }
}
