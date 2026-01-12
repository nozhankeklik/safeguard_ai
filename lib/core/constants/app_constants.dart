import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan sabitler
class AppConstants {
  AppConstants._();

  // Spacing & Padding
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 20.0;
  static const double spacingXXLarge = 24.0;
  static const double spacingXXXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  // Card Elevation
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // Image Heights
  static const double imageHeightPreview = 200.0;

  // Text Field
  static const int maxLinesEmailBody = 12;
  static const int minCharactersSubject = 5;
  static const int minCharactersBody = 10;

  // Animation
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);
}

/// Risk seviyeleri için renkler (Monokrom - gri tonları)
class RiskColors {
  RiskColors._();

  // YÜKSEK - Koyu gri
  static const highRiskPrimary = Color(0xFF1A1A1A); // Dark Gray
  static const highRiskLight = Color(0xFFF5F5F5); // Light Gray
  static const highRiskDark = Color(0xFF0A0A0A); // Very Dark Gray

  // ORTA - Orta gri
  static const mediumRiskPrimary = Color(0xFF4A4A4A); // Medium Gray
  static const mediumRiskLight = Color(0xFFF5F5F5); // Light Gray
  static const mediumRiskDark = Color(0xFF2A2A2A); // Dark Gray

  // DÜŞÜK - Açık gri
  static const lowRiskPrimary = Color(0xFF6B7280); // Light Gray
  static const lowRiskLight = Color(0xFFF5F5F5); // Light Gray
  static const lowRiskDark = Color(0xFF4A4A4A); // Medium Gray

  // Varsayılan
  static const defaultPrimary = Color(0xFF6B7280); // Gray
  static const defaultLight = Color(0xFFF9FAFB); // Light Gray
}
