import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Basit tema yönetimi - ValueNotifier ile
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  ThemeNotifier(super.value);

  /// Temayı değiştir ve kaydet
  Future<void> setThemeMode(ThemeMode mode) async {
    value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }

  /// Dark mode mu?
  bool get isDarkMode => value == ThemeMode.dark;

  /// Light mode mu?
  bool get isLightMode => value == ThemeMode.light;

  /// Dark mode'a geç
  Future<void> setDarkMode() => setThemeMode(ThemeMode.dark);

  /// Light mode'a geç
  Future<void> setLightMode() => setThemeMode(ThemeMode.light);

  /// Toggle (değiştir)
  Future<void> toggleTheme() {
    return isDarkMode ? setLightMode() : setDarkMode();
  }

  /// Kaydedilmiş temayı yükle
  static Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themeKey);
    
    if (themeName == ThemeMode.dark.name) {
      return ThemeMode.dark;
    } else if (themeName == ThemeMode.light.name) {
      return ThemeMode.light;
    }
    
    // Varsayılan: Light mode
    return ThemeMode.light;
  }
}
