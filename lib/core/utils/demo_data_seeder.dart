import 'dart:math';
import 'package:safeguard_ai/features/analysis/data/models/report_hive_model.dart';
import 'package:safeguard_ai/features/analysis/data/repositories/report_local_repository.dart';
import 'package:uuid/uuid.dart';

/// 🎭 Demo Data Seeder - Sunum için örnek raporlar oluşturur
class DemoDataSeeder {
  final ReportLocalRepository _repository;
  final Random _random = Random();
  final Uuid _uuid = const Uuid();

  DemoDataSeeder(this._repository);

  /// Demo raporları oluştur (zaten varsa oluşturma)
  Future<void> seedDemoReports({int count = 10}) async {
    final existingReports = _repository.getAllReports();

    // Eğer zaten rapor varsa, demo data oluşturma
    if (existingReports.isNotEmpty) {
      // ignore: avoid_print
      print('✅ Mevcut ${existingReports.length} rapor bulundu. Demo data eklenmedi.');
      return;
    }

    // ignore: avoid_print
    print('🎭 $count adet demo rapor oluşturuluyor...');

    for (int i = 0; i < count; i++) {
      final report = _generateRandomReport(i);
      await _repository.saveReport(report);
    }

    // ignore: avoid_print
    print('✅ Demo raporlar başarıyla oluşturuldu!');
  }

  ReportHiveModel _generateRandomReport(int index) {
    final riskLevel = _getRandomRiskLevel();
    final timestamp = DateTime.now().subtract(Duration(days: _random.nextInt(30), hours: _random.nextInt(24)));

    return ReportHiveModel(
      id: _uuid.v4(),
      analysis: _getRandomAnalysis(riskLevel),
      riskLevel: riskLevel,
      imagePath: 'demo_image_$index.jpg', // Sahte resim yolu
      timestamp: timestamp,
      emailSubject: _getEmailSubject(riskLevel),
      emailBody: _getEmailBody(riskLevel, timestamp),
      recipients: _getRandomRecipients(riskLevel),
      ccRecipients: _random.nextBool() ? ['yonetim@sirket.com'] : [],
      emailSent: _random.nextBool(),
      savedToGoogleDrive: _random.nextBool(),
      pdfGenerated: _random.nextBool(),
    );
  }

  String _getRandomRiskLevel() {
    final value = _random.nextInt(100);
    if (value < 20) return 'YÜKSEK';
    if (value < 60) return 'ORTA';
    return 'DÜŞÜK';
  }

  String _getRandomAnalysis(String riskLevel) {
    final analyses = {
      'YÜKSEK': [
        'Çalışan baret kullanmıyor ve yüksekte çalışıyor. Acil müdahale gerekli.',
        'İskele güvensiz durumda, korkuluk eksik. Derhal durdurulmalı.',
        'Elektrik panosu açık, izolasyon yok. Yaşamsal risk mevcut.',
        'Yüksek gerilim hattının yakınında koruyucu ekipman olmadan çalışılıyor.',
        'Ağır yük taşıma sırasında güvenlik kemeri kullanılmamış.',
      ],
      'ORTA': [
        'Çalışma alanında düzensizlik var. Kablolar yerde, takılma riski mevcut.',
        'Koruyucu ekipman kullanımı eksik. Eldiven ve gözlük takılmamış.',
        'Yerde sıvı dökülmesi var, kayganlık riski. Temizlik yapılmalı.',
        'Acil çıkış yolu kısmen engelli. Düzenleme gerekiyor.',
        'İşçi hatalı duruşta çalışıyor, ergonomik risk tespit edildi.',
      ],
      'DÜŞÜK': [
        'Genel iş güvenliği kurallarına uygun çalışma görünüyor.',
        'Çalışma alanı düzenli ve temiz. Güvenlik önlemleri alınmış.',
        'Ekipman kullanımı uygun, ortam güvenli. Önemli risk tespit edilmedi.',
        'Tüm personel koruyucu ekipman kullanıyor. Düzenli kontroller yapılmış.',
        'Çalışma alanı standartlara uygun. Rutin takip yeterli.',
      ],
    };

    final list = analyses[riskLevel]!;
    return list[_random.nextInt(list.length)];
  }

  String _getEmailSubject(String riskLevel) {
    switch (riskLevel) {
      case 'YÜKSEK':
        return '🚨 ACİL: Yüksek Riskli İş Güvenliği Tespiti';
      case 'ORTA':
        return '⚠️ DİKKAT: Orta Seviye İş Güvenliği Uyarısı';
      case 'DÜŞÜK':
        return 'ℹ️ BİLGİ: İş Güvenliği Kontrol Raporu';
      default:
        return '📋 İş Güvenliği Raporu';
    }
  }

  String _getEmailBody(String riskLevel, DateTime timestamp) {
    return '''
Sayın İlgili,

${timestamp.day}.${timestamp.month}.${timestamp.year} ${timestamp.hour}:${timestamp.minute} tarihinde yapılan iş güvenliği kontrolünde aşağıdaki tespit yapılmıştır.

RİSK SEVİYESİ: $riskLevel

Saygılarımızla,
SafeGuard AI Sistemi
    ''';
  }

  List<String> _getRandomRecipients(String riskLevel) {
    switch (riskLevel) {
      case 'YÜKSEK':
        return ['guvenlik@sirket.com', 'mudur@sirket.com', 'isg@sirket.com'];
      case 'ORTA':
        return ['isg@sirket.com', 'raporlama@sirket.com'];
      case 'DÜŞÜK':
        return ['raporlama@sirket.com'];
      default:
        return ['isg@sirket.com'];
    }
  }
}
