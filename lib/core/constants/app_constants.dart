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

/// Risk seviyeleri için renkler (Material Design 3 uyumlu)
class RiskColors {
  RiskColors._();

  // YÜKSEK - Kırmızı tonları (okunabilir)
  static const highRiskPrimary = Color(0xFFD32F2F); // Material Red 700
  static const highRiskLight = Color(0xFFFFCDD2); // Material Red 100
  static const highRiskDark = Color(0xFFB71C1C); // Material Red 900

  // ORTA - Turuncu tonları (okunabilir)
  static const mediumRiskPrimary = Color(0xFFF57C00); // Material Orange 700
  static const mediumRiskLight = Color(0xFFFFE0B2); // Material Orange 100
  static const mediumRiskDark = Color(0xFFE65100); // Material Orange 900

  // DÜŞÜK - Yeşil tonları (okunabilir)
  static const lowRiskPrimary = Color(0xFF388E3C); // Material Green 700
  static const lowRiskLight = Color(0xFFC8E6C9); // Material Green 100
  static const lowRiskDark = Color(0xFF1B5E20); // Material Green 900

  // Varsayılan
  static const defaultPrimary = Color(0xFF757575); // Material Grey 600
  static const defaultLight = Color(0xFFEEEEEE); // Material Grey 200
}
