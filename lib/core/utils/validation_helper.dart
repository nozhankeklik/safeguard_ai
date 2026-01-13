/// Validation helper utility
/// 
/// Provides common validation functions for user input.
class ValidationHelper {
  ValidationHelper._();

  /// Validate email address format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email.trim());
  }

  /// Validate text is not empty
  static bool isNotEmpty(String? text) {
    return text != null && text.trim().isNotEmpty;
  }

  /// Validate text length
  static bool isValidLength(String text, {int min = 0, int? max}) {
    if (text.length < min) return false;
    if (max != null && text.length > max) return false;
    return true;
  }

  /// Validate risk level
  static bool isValidRiskLevel(String riskLevel) {
    const validLevels = ['YÜKSEK', 'HIGH', 'ORTA', 'MEDIUM', 'DÜŞÜK', 'LOW'];
    return validLevels.contains(riskLevel.toUpperCase());
  }
}
