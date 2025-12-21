class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://localhost:5678';
  static const String analyzeEndpoint = '/webhook/analyze';
  static const Duration connectionTimeout = Duration(seconds: 30);
}
