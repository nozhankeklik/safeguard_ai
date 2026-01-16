import 'package:shared_preferences/shared_preferences.dart';

/// Default recipients servisi - Risk seviyelerine göre email alıcılarını yönetir
class DefaultRecipientsService {
  static const String _keyLowRisk = 'default_recipients_low';
  static const String _keyMediumRisk = 'default_recipients_medium';
  static const String _keyHighRisk = 'default_recipients_high';

  // Default değerler
  static const List<String> _defaultLowRisk = ['ozhankeklik2001@gmail.com'];
  static const List<String> _defaultMediumRisk = [
    'ozhankeklik2001@gmail.com',
    'nozhankeklik@gmail.com',
  ];
  static const List<String> _defaultHighRisk = [
    'ozhankeklik2001@gmail.com',
    'nozhankeklik@gmail.com',
    'nihatozhan.keklik@agu.edu.tr',
  ];

  /// Düşük risk için default alıcıları getir
  static Future<List<String>> getLowRiskRecipients() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_keyLowRisk);
    return saved ?? _defaultLowRisk;
  }

  /// Orta risk için default alıcıları getir
  static Future<List<String>> getMediumRiskRecipients() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_keyMediumRisk);
    return saved ?? _defaultMediumRisk;
  }

  /// Yüksek risk için default alıcıları getir
  static Future<List<String>> getHighRiskRecipients() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_keyHighRisk);
    return saved ?? _defaultHighRisk;
  }

  /// Risk seviyesine göre default alıcıları getir
  static Future<List<String>> getDefaultRecipients(String riskLevel) async {
    switch (riskLevel.toUpperCase()) {
      case 'YÜKSEK':
      case 'HIGH':
        return getHighRiskRecipients();
      case 'ORTA':
      case 'MEDIUM':
        return getMediumRiskRecipients();
      case 'DÜŞÜK':
      case 'LOW':
        return getLowRiskRecipients();
      default:
        return getLowRiskRecipients();
    }
  }

  /// Düşük risk için alıcıları kaydet
  static Future<bool> saveLowRiskRecipients(List<String> recipients) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(_keyLowRisk, recipients);
  }

  /// Orta risk için alıcıları kaydet
  static Future<bool> saveMediumRiskRecipients(List<String> recipients) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(_keyMediumRisk, recipients);
  }

  /// Yüksek risk için alıcıları kaydet
  static Future<bool> saveHighRiskRecipients(List<String> recipients) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(_keyHighRisk, recipients);
  }

  /// Risk seviyesine göre alıcıları kaydet
  static Future<bool> saveRecipients(String riskLevel, List<String> recipients) async {
    switch (riskLevel.toUpperCase()) {
      case 'YÜKSEK':
      case 'HIGH':
        return saveHighRiskRecipients(recipients);
      case 'ORTA':
      case 'MEDIUM':
        return saveMediumRiskRecipients(recipients);
      case 'DÜŞÜK':
      case 'LOW':
        return saveLowRiskRecipients(recipients);
      default:
        return saveLowRiskRecipients(recipients);
    }
  }

  /// Tüm default değerleri sıfırla
  static Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyLowRisk, _defaultLowRisk);
    await prefs.setStringList(_keyMediumRisk, _defaultMediumRisk);
    await prefs.setStringList(_keyHighRisk, _defaultHighRisk);
  }
}
