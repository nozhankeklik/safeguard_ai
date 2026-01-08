import 'dart:convert';
import 'dart:io';

/// n8n'e rapor gönderme request modeli
class SendReportRequest {
  final String imagePath;
  final String analysis;
  final String riskLevel;
  final String emailSubject;
  final String emailBody;
  final List<String> recipients;
  final List<String> ccRecipients;
  final bool saveToGoogleDocs;
  final bool generatePdf;

  SendReportRequest({
    required this.imagePath,
    required this.analysis,
    required this.riskLevel,
    required this.emailSubject,
    required this.emailBody,
    required this.recipients,
    this.ccRecipients = const [],
    this.saveToGoogleDocs = false,
    this.generatePdf = false,
  });

  Map<String, dynamic> toJson() {
    // Resmi base64'e çevir
    final imageFile = File(imagePath);
    final imageBytes = imageFile.readAsBytesSync();
    final base64Image = base64Encode(imageBytes);

    return {
      'image': base64Image,
      'imageName': imagePath.split('/').last,
      'analysis': analysis,
      'riskLevel': riskLevel,
      'emailSubject': emailSubject,
      'emailBody': emailBody,
      'recipients': recipients,
      'ccRecipients': ccRecipients,
      'saveToGoogleDocs': saveToGoogleDocs,
      'generatePdf': generatePdf,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
