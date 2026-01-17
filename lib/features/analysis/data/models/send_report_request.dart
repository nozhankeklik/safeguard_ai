import 'dart:convert';
import 'dart:io';

/// V2 Backend - n8n'e final rapor gönderme request modeli
/// Basitleştirilmiş format: sadece gerekli alanlar
class SendReportRequest {
  final String imagePath;
  final String finalMessage; // Kullanıcının düzenlediği analiz metni
  final String riskLevel;
  final String recipient; // Tek bir alıcı email
  final String subject; // Email başlığı
  final List<String>? correctiveActions; // Gemini'den gelen düzeltici aksiyonlar

  SendReportRequest({
    required this.imagePath,
    required this.finalMessage,
    required this.riskLevel,
    required this.recipient,
    required this.subject,
    this.correctiveActions,
  });

  Map<String, dynamic> toJson() {
    // Resmi base64'e çevir
    final imageFile = File(imagePath);
    final imageBytes = imageFile.readAsBytesSync();
    final base64Image = base64Encode(imageBytes);

    // V2 Backend formatı - sadece gerekli alanlar
    return {
      'image': base64Image,
      'final_message': finalMessage,
      'riskLevel': riskLevel,
      'recipient': recipient,
      'subject': subject,
      'corrective_actions': correctiveActions,
    };
  }
}
