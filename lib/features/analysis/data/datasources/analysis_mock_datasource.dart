import 'dart:math';
import 'package:safeguard_ai/features/analysis/data/models/analysis_response_model.dart';
import 'analysis_remote_datasource.dart';

/// 🎭 Mock DataSource - Geliştirme için sahte veri
/// n8n hazır olunca otomatik devre dışı kalacak
/// 
/// Kullanım: injection_container.dart'ta _useMockData flag'i ile kontrol edilir
class AnalysisMockDataSource implements AnalysisRemoteDataSource {
  final Random _random = Random();
  
  @override
  Future<AnalysisResponseModel> analyzeImage(String imagePath) async {
    // Gerçekçi network gecikmesi simülasyonu (2-3 saniye)
    await Future.delayed(const Duration(seconds: 2, milliseconds: 500));
    
    // Random risk seç (%30 düşük, %50 orta, %20 yüksek)
    final randomValue = _random.nextInt(100);
    String riskLevel;
    
    if (randomValue < 30) {
      riskLevel = 'DÜŞÜK';
    } else if (randomValue < 80) {
      riskLevel = 'ORTA';
    } else {
      riskLevel = 'YÜKSEK';
    }
    
    // Risk seviyesine göre gerçekçi analiz metni üret
    final analysis = _getMockAnalysis(riskLevel);
    
    // Backend ile aynı formatta response döndür
    return AnalysisResponseModel(
      success: true,
      analysis: analysis,
      riskLevel: riskLevel,
    );
  }
  
  /// Risk seviyesine göre gerçekçi analiz metinleri
  String _getMockAnalysis(String riskLevel) {
    final Map<String, List<String>> analyses = {
      'YÜKSEK': [
        'Çalışan baret kullanmıyor ve yüksekte çalışıyor. Acil müdahale gerekli. Yüksekten düşme riski çok yüksek.',
        'İskele güvensiz durumda, korkuluk eksik. Çalışanlar koruyucu ekipman kullanmıyor. Derhal durdurulmalı.',
        'Elektrik panosu açık, izolasyon yok. Yaşamsal elektrik çarpması riski mevcut. Acil kapatılmalı.',
        'Ağır yük asılı durumda, altında çalışanlar var. Düşme riski kritik seviyede. Alan boşaltılmalı.',
        'Güvenlik bariyerleri yok, yüksek seviye düşme tehlikesi. Çalışma derhal durdurulmalı.',
      ],
      'ORTA': [
        'Çalışma alanında düzensizlik var. Kablolar yerde, takılma riski mevcut. Düzenleme önerilir.',
        'Koruyucu ekipman kullanımı eksik. Eldiven ve gözlük takılmamış. Uyarı gerekiyor.',
        'Yerde sıvı dökülmesi var, kayganlık riski. Temizlik yapılmalı ve uyarı levhası konmalı.',
        'Havalandırma yetersiz, toz oluşumu fazla. Maske kullanımı önerilir ve ortam havalandırılmalı.',
        'Ekipman düzensiz yerleştirilmiş. Çarpma ve takılma riski var. Düzenleme gerekiyor.',
      ],
      'DÜŞÜK': [
        'Genel iş güvenliği kurallarına uygun çalışma görünüyor. Koruyucu ekipmanlar kullanılmış.',
        'Çalışma alanı düzenli ve temiz. Güvenlik önlemleri alınmış. Rutin takip yeterli.',
        'Ekipman kullanımı uygun, ortam güvenli. Önemli bir risk tespit edilmedi.',
        'İş güvenliği standartlarına uygun durum. Mevcut önlemler yeterli görünüyor.',
        'Koruyucu ekipman tam, alan düzenli. İyi güvenlik uygulaması gözlemlendi.',
      ],
    };
    
    final list = analyses[riskLevel]!;
    return list[_random.nextInt(list.length)];
  }
}
