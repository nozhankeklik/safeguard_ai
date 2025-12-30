import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:safeguard_ai/core/constants/api_constants.dart';

/// Platform-specific configuration helper
/// Android Emulator ve diğer platformlar için base URL yönetimi
class PlatformConfig {
  PlatformConfig._();

  /// Platform ve çalışma ortamına göre uygun base URL'i döndürür
  /// 
  /// - Android Emulator: 10.0.2.2 (localhost'un emulator'deki karşılığı)
  /// - iOS Simulator: localhost
  /// - Fiziksel Cihaz: Local network IP kullanmanız gerekir
  static String getBaseUrl() {
    // Debug modda ve Android platformunda ise emulator kontrolü
    if (kDebugMode && !kIsWeb) {
      if (Platform.isAndroid) {
        // Android Emulator için özel base URL
        return ApiConstants.baseUrlAndroidEmulator;
      }
    }
    
    // Diğer durumlar için standart base URL
    return ApiConstants.baseUrl;
  }

  /// Fiziksel cihazda test için local network IP kullanımı
  /// Örnek: PlatformConfig.useCustomBaseUrl('http://192.168.1.100:5678')
  static String? _customBaseUrl;

  static void useCustomBaseUrl(String url) {
    _customBaseUrl = url;
  }

  static void resetBaseUrl() {
    _customBaseUrl = null;
  }

  /// Custom base URL varsa onu, yoksa platform-specific URL'i döndürür
  static String getActiveBaseUrl() {
    return _customBaseUrl ?? getBaseUrl();
  }
}

