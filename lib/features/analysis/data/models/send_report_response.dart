/// n8n'den dönen rapor response modeli
class SendReportResponse {
  final bool success;
  final bool emailSent;
  final bool driveFileCreated;
  final bool pdfGenerated;
  final String? driveFileUrl;
  final String? pdfUrl;
  final String? message;

  SendReportResponse({
    required this.success,
    this.emailSent = false,
    this.driveFileCreated = false,
    this.pdfGenerated = false,
    this.driveFileUrl,
    this.pdfUrl,
    this.message,
  });

  factory SendReportResponse.fromJson(Map<String, dynamic> json) {
    return SendReportResponse(
      success: json['success'] ?? false,
      emailSent: json['emailSent'] ?? false,
      driveFileCreated: json['driveFileCreated'] ?? false,
      pdfGenerated: json['pdfGenerated'] ?? false,
      driveFileUrl: json['driveFileUrl'],
      pdfUrl: json['pdfUrl'],
      message: json['message'],
    );
  }
}
