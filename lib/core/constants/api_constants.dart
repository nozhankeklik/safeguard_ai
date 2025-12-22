class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://192.168.1.5:5678';
  static const analyzeEndpoint = '/webhook-test/analyze';
  static const Duration connectionTimeout = Duration(seconds: 30);
}
