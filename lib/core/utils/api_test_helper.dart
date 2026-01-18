import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'platform_config.dart';
import '../constants/api_constants.dart';

/// Backend API'nin çalışıp çalışmadığını test etmek için helper sınıf
/// Bu sınıf sadece development/debug sırasında kullanılmalıdır
class ApiTestHelper {
  ApiTestHelper._();

  /// Backend bağlantısını test eder
  ///
  /// Returns: Bağlantı durumu ve mesaj
  static Future<Map<String, dynamic>> testConnection() async {
    if (!kDebugMode) {
      return {'success': false, 'message': 'Bu fonksiyon sadece debug modda çalışır'};
    }

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: PlatformConfig.getActiveBaseUrl(),
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      debugPrint('🔍 Testing connection to: ${PlatformConfig.getActiveBaseUrl()}');

      // Basit bir GET isteği ile backend'in erişilebilir olup olmadığını kontrol et
      final response = await dio.get('/');

      debugPrint('✅ Connection successful! Status: ${response.statusCode}');

      return {
        'success': true,
        'message': 'Backend\'e başarıyla bağlandı',
        'baseUrl': PlatformConfig.getActiveBaseUrl(),
        'statusCode': response.statusCode,
      };
    } on DioException catch (e) {
      String errorMessage;

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Bağlantı zaman aşımına uğradı';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'Backend\'e bağlanılamıyor. n8n çalışıyor mu?';
          break;
        case DioExceptionType.badResponse:
          errorMessage = 'Sunucu hata döndü: ${e.response?.statusCode}';
          break;
        default:
          errorMessage = 'Bilinmeyen hata: ${e.message}';
      }

      debugPrint('❌ Connection failed: $errorMessage');

      return {
        'success': false,
        'message': errorMessage,
        'baseUrl': PlatformConfig.getActiveBaseUrl(),
        'error': e.message,
      };
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');

      return {'success': false, 'message': 'Beklenmeyen hata: $e', 'baseUrl': PlatformConfig.getActiveBaseUrl()};
    }
  }

  /// Webhook endpoint'ini test eder (gerçek bir analiz isteği göndermeden)
  static Future<Map<String, dynamic>> testWebhookEndpoint() async {
    if (!kDebugMode) {
      return {'success': false, 'message': 'Bu fonksiyon sadece debug modda çalışır'};
    }

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: PlatformConfig.getActiveBaseUrl(),
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      final fullUrl = '${PlatformConfig.getActiveBaseUrl()}${ApiConstants.analyzeEndpoint}';
      debugPrint('🔍 Testing webhook: $fullUrl');

      // HEAD request ile endpoint'in var olup olmadığını kontrol et
      final response = await dio.head(ApiConstants.analyzeEndpoint);

      debugPrint('✅ Webhook endpoint accessible! Status: ${response.statusCode}');

      return {
        'success': true,
        'message': 'Webhook endpoint\'e erişilebilir',
        'endpoint': fullUrl,
        'statusCode': response.statusCode,
      };
    } on DioException catch (e) {
      // 404 veya 405 alırsak, endpoint muhtemelen POST bekliyor (bu normal)
      if (e.response?.statusCode == 404 || e.response?.statusCode == 405) {
        final fullUrl = '${PlatformConfig.getActiveBaseUrl()}${ApiConstants.analyzeEndpoint}';
        debugPrint('⚠️ Endpoint exists but needs POST request (normal behavior)');

        return {
          'success': true,
          'message': 'Webhook endpoint mevcut (POST isteği bekliyor)',
          'endpoint': fullUrl,
          'statusCode': e.response?.statusCode,
        };
      }

      debugPrint('❌ Webhook test failed: ${e.message}');

      return {
        'success': false,
        'message': 'Webhook endpoint\'e erişilemiyor: ${e.message}',
        'endpoint': '${PlatformConfig.getActiveBaseUrl()}${ApiConstants.analyzeEndpoint}',
      };
    } catch (e) {
      debugPrint('❌ Unexpected error: $e');

      return {
        'success': false,
        'message': 'Beklenmeyen hata: $e',
        'endpoint': '${PlatformConfig.getActiveBaseUrl()}${ApiConstants.analyzeEndpoint}',
      };
    }
  }

  /// Platform ve bağlantı bilgilerini ekrana yazdırır
  static void printConnectionInfo() {
    if (!kDebugMode) return;

    debugPrint('');
    debugPrint('═══════════════════════════════════════');
    debugPrint('📡 API CONNECTION INFO');
    debugPrint('═══════════════════════════════════════');
    debugPrint('Base URL: ${PlatformConfig.getActiveBaseUrl()}');
    debugPrint('Endpoint: ${ApiConstants.analyzeEndpoint}');
    debugPrint('Full URL: ${PlatformConfig.getActiveBaseUrl()}${ApiConstants.analyzeEndpoint}');
    debugPrint('Platform: $defaultTargetPlatform');
    debugPrint('═══════════════════════════════════════');
    debugPrint('');
  }
}
