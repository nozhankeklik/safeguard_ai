class ApiConstants {
  ApiConstants._();

  // Base URL için platform kontrolü yapılabilir
  // Android Emulator için: 'http://10.0.2.2:5678'
  // iOS Simulator/Fiziksel Cihaz için: Local IP veya localhost
  static const String baseUrl = 'http://localhost:5678';

  // n8n webhook endpoint (tam path: /webhook-test/test)
  static const analyzeEndpoint = '/webhook-test/test';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // Android Emulator için alternatif base URL
  static const String baseUrlAndroidEmulator = 'http://10.0.2.2:5678';
}
