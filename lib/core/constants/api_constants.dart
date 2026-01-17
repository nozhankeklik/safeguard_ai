class ApiConstants {
  ApiConstants._();

  // Base URL için platform kontrolü yapılabilir
  // Android Emulator için: 'http://10.0.2.2:5678'
  // iOS Simulator/Fiziksel Cihaz için: Local IP veya localhost
  static const String baseUrl = 'http://localhost:5678';

  // V2 Backend - n8n webhook endpoints
  // Analyze endpoint: POST http://localhost:5678/webhook-test/analyze
  static const analyzeEndpoint = '/webhook-test/analyze';

  // Send final report endpoint: POST http://localhost:5678/webhook-test/send
  static const sendReportEndpoint = '/webhook-test/send';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // Android Emulator için alternatif base URL
  static const String baseUrlAndroidEmulator = 'http://10.0.2.2:5678';
}
