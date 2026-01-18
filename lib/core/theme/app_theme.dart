import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // --- RENK PALETİ (Güven Veren Indigo) ---
  // Light Mode Renkleri
  static const Color _lightPrimaryColor = Color(0xFF3949AB); // Indigo 600 (Ana Marka Rengi)
  static const Color _lightSecondaryColor = Color(0xFF5C6BC0); // Indigo 400
  static const Color _lightBackgroundColor = Color(0xFFF8F9FA); // Çok açık gri/beyaz (Off-white)
  static const Color _lightSurfaceColor = Colors.white;
  static const Color _lightErrorColor = Color(0xFFB91C1C);

  // Dark Mode Renkleri
  static const Color _darkPrimaryColor = Color(0xFF7986CB); // Indigo 300 (Karanlıkta parlamayan yumuşak ton)
  static const Color _darkBackgroundColor = Color(0xFF121212);
  static const Color _darkSurfaceColor = Color(0xFF1E1E1E);

  /// ☀️ LIGHT THEME
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightBackgroundColor,

      // Renk Şeması
      colorScheme: const ColorScheme.light(
        primary: _lightPrimaryColor,
        secondary: _lightSecondaryColor,
        surface: _lightSurfaceColor,
        background: _lightBackgroundColor,
        error: _lightErrorColor,
        // Yüzey üzerindeki yazı renkleri
        onPrimary: Colors.white,
        onSurface: Color(0xFF1A1A1A),
      ),

      // AppBar (Temiz ve Kurumsal)
      appBarTheme: AppBarTheme(
        backgroundColor: _lightSurfaceColor,
        foregroundColor: _lightPrimaryColor,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _lightPrimaryColor, // Başlıklar marka renginde
          letterSpacing: -0.3,
        ),
        iconTheme: const IconThemeData(color: _lightPrimaryColor),
      ),

      // Kartlar (Hafif Gölgeli, Modern)
      cardTheme: CardThemeData(
        color: _lightSurfaceColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05), // Çok yumuşak gölge
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade100), // Çok hafif kenarlık
        ),
      ),

      // Dolgulu Butonlar
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Biraz daha yumuşak köşe
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.2),
        ),
      ),

      // Metin Butonları
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Çerçeveli Butonlar
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightPrimaryColor,
          side: const BorderSide(color: _lightSecondaryColor, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Input Alanları (Temiz Form)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightPrimaryColor, width: 2), // Odaklanınca marka rengi
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightErrorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Alt Navigasyon Teması (GÜNCELLENDİ)
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0, // Gölgeyi kapattık (MainShellPage'de border vereceğiz)
        // Seçili Durum (Indigo Mavi)
        selectedItemColor: _lightPrimaryColor,
        selectedIconTheme: const IconThemeData(size: 26), // Seçilince ikon hafif büyür
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600, // Yazı kalınlaşır
          letterSpacing: -0.2,
        ),

        // Seçili Olmayan Durum (Gri)
        unselectedItemColor: Colors.grey.shade500,
        unselectedIconTheme: const IconThemeData(size: 24),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: -0.2),

        type: BottomNavigationBarType.fixed, // İkonlar sabit durur, kaymaz
        showUnselectedLabels: true, // Yazılar her zaman görünür
      ),

      // Tipografi
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme.apply(
          bodyColor: const Color(0xFF1F2937), // Koyu Gri (Okunaklı)
          displayColor: const Color(0xFF111827), // Neredeyse Siyah
        ),
      ),
    );
  }

  /// 🌙 DARK THEME
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBackgroundColor,

      colorScheme: const ColorScheme.dark(
        primary: _darkPrimaryColor,
        secondary: _darkPrimaryColor,
        surface: _darkSurfaceColor,
        background: _darkBackgroundColor,
        error: Color(0xFFEF5350),
        onPrimary: Colors.black, // Buton üzerindeki yazı siyah (okunabilirlik için)
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurfaceColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),

      cardTheme: CardThemeData(
        color: _darkSurfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withOpacity(0.05)), // Hafif kenarlık
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimaryColor,
          foregroundColor: Colors.black, // Dark modda buton yazısı koyu olmalı
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkPrimaryColor,
          side: const BorderSide(color: _darkPrimaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: _darkPrimaryColor, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkSurfaceColor,
        selectedItemColor: _darkPrimaryColor,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
      ),

      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );
  }
}
