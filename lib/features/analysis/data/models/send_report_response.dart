/// n8n'den dönen rapor response modeli
class SendReportResponse {
  final bool success;
  final bool emailSent;
  final bool docsCreated;
  final bool pdfGenerated;
  final String? docsUrl;
  final String? pdfUrl;
  final String? message;

  SendReportResponse({
    required this.success,
    this.emailSent = false,
    this.docsCreated = false,
    this.pdfGenerated = false,
    this.docsUrl,
    this.pdfUrl,
    this.message,
  });

  factory SendReportResponse.fromJson(Map<String, dynamic> json) {
    return SendReportResponse(
      success: json['success'] ?? false,
      emailSent: json['emailSent'] ?? false,
      docsCreated: json['docsCreated'] ?? false,
      pdfGenerated: json['pdfGenerated'] ?? false,
      docsUrl: json['docsUrl'],
      pdfUrl: json['pdfUrl'],
      message: json['message'],
    );
  }
}
