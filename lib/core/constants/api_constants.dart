class ApiConstants {
  ApiConstants._();

  // Base URL için platform kontrolü yapılabilir
  // Android Emulator için: 'http://10.0.2.2:5678'
  // iOS Simulator/Fiziksel Cihaz için: Local IP veya localhost
  static const String baseUrl = 'http://localhost:5678';

  // n8n webhook endpoint (tam path: /webhook-test/test)
  static const analyzeEndpoint = '/webhook-test/test';

  // n8n email gönderme endpoint (tam path: /webhook/send-report)
  static const sendReportEndpoint = '/webhook/send-report';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // Android Emulator için alternatif base URL
  static const String baseUrlAndroidEmulator = 'http://10.0.2.2:5678';
}
