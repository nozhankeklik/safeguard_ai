import 'package:intl/intl.dart';
import '../services/default_recipients_service.dart';
import '../../features/analysis/domain/entities/analysis_entity.dart';

/// Mail şablonları oluşturan yardımcı sınıf
class EmailTemplateGenerator {
  EmailTemplateGenerator._();

  /// Risk seviyesine göre mail başlığı oluştur
  static String generateSubject(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'YÜKSEK':
      case 'HIGH':
        return '🚨 ACİL: Yüksek Riskli İş Güvenliği Tespiti';
      case 'ORTA':
      case 'MEDIUM':
        return '⚠️ DİKKAT: Orta Seviye İş Güvenliği Uyarısı';
      case 'DÜŞÜK':
      case 'LOW':
        return 'ℹ️ BİLGİ: İş Güvenliği Kontrol Raporu';
      default:
        return '📋 İş Güvenliği Raporu';
    }
  }

  /// Risk seviyesine göre mail içeriği oluştur
  static String generateBody(AnalysisEntity analysis, DateTime timestamp) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final formattedDate = dateFormat.format(timestamp);

    return '''Sayın İlgili,

$formattedDate tarihinde yapılan iş güvenliği kontrolünde aşağıdaki tespit yapılmıştır:

🔍 TESPİT EDİLEN DURUM:
${analysis.analysisText}

⚠️ RİSK SEVİYESİ: ${analysis.riskLevel}

📸 Fotoğraf ekte mevcuttur.

${_getActionRecommendation(analysis.riskLevel)}

Saygılarımızla,
SafeGuard AI Sistemi

---
Bu rapor otomatik olarak oluşturulmuştur.
Tarih: $formattedDate
''';
  }

  /// Risk seviyesine göre aksiyon önerileri
  static String _getActionRecommendation(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'YÜKSEK':
      case 'HIGH':
        return '''
🚨 HEMEN YAPILMASI GEREKENLER:
• İlgili alan derhal kapatılmalı
• Çalışanlar bilgilendirilmeli
• Düzeltici aksiyonlar acil başlatılmalı
• Yönetim ekibi bilgilendirilmeli
''';
      case 'ORTA':
      case 'MEDIUM':
        return '''
⚠️ ÖNERİLER:
• Durum 24 saat içinde kontrol edilmeli
• Gerekli önlemler alınmalı
• Personel bilgilendirilmeli
• Takip raporu hazırlanmalı
''';
      case 'DÜŞÜK':
      case 'LOW':
        return '''
ℹ️ BİLGİ:
• Rutin kontroller devam edilmeli
• Kayıt altına alınmalı
• Mevcut güvenlik önlemlerine devam edilmeli
''';
      default:
        return '''
ℹ️ BİLGİ:
• İlgili birimler kontrol yapmalı
• Kayıt altına alınmalı
''';
    }
  }

  /// Risk seviyesine göre öntanımlı alıcı listesi
  /// Not: Bu fonksiyon async değil, bu yüzden sync bir versiyon da sağlıyoruz
  /// Async versiyon için DefaultRecipientsService.getDefaultRecipients() kullanın
  static List<String> getDefaultRecipientsSync(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'YÜKSEK':
      case 'HIGH':
        return ['ozhankeklik2001@gmail.com', 'nozhankeklik@gmail.com', 'nihatozhan.keklik@agu.edu.tr'];
      case 'ORTA':
      case 'MEDIUM':
        return ['ozhankeklik2001@gmail.com', 'nozhankeklik@gmail.com'];
      case 'DÜŞÜK':
      case 'LOW':
        return ['ozhankeklik2001@gmail.com'];
      default:
        return ['ozhankeklik2001@gmail.com'];
    }
  }

  /// Risk seviyesine göre öntanımlı alıcı listesi (async - SharedPreferences'tan okur)
  static Future<List<String>> getDefaultRecipients(String riskLevel) async {
    return DefaultRecipientsService.getDefaultRecipients(riskLevel);
  }

  /// Email validasyonu
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email.trim());
  }
}
