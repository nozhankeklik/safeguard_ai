import 'package:hive/hive.dart';
import '../models/report_hive_model.dart';

/// Local Repository - Hive ile CRUD işlemleri
class ReportLocalRepository {
  static const String _boxName = 'reports';

  Box<ReportHiveModel> get _box => Hive.box<ReportHiveModel>(_boxName);

  /// Tüm raporları getir (en yeni önce)
  List<ReportHiveModel> getAllReports() {
    final reports = _box.values.toList();
    reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return reports;
  }

  /// Belirli bir raporu ID ile getir
  ReportHiveModel? getReportById(String id) {
    return _box.get(id);
  }

  /// Risk seviyesine göre filtrele
  List<ReportHiveModel> getReportsByRiskLevel(String riskLevel) {
    final reports = _box.values.where((report) => report.riskLevel.toUpperCase() == riskLevel.toUpperCase()).toList();
    reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return reports;
  }

  /// Tarih aralığına göre filtrele
  List<ReportHiveModel> getReportsByDateRange(DateTime start, DateTime end) {
    final reports = _box.values
        .where((report) => report.timestamp.isAfter(start) && report.timestamp.isBefore(end))
        .toList();
    reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return reports;
  }

  /// Yeni rapor kaydet
  Future<void> saveReport(ReportHiveModel report) async {
    await _box.put(report.id, report);
  }

  /// Rapor güncelle
  Future<void> updateReport(ReportHiveModel report) async {
    await _box.put(report.id, report);
  }

  /// Rapor sil
  Future<void> deleteReport(String id) async {
    await _box.delete(id);
  }

  /// Tüm raporları sil
  Future<void> deleteAllReports() async {
    await _box.clear();
  }

  /// İstatistikler - Risk seviyesine göre sayı
  Map<String, int> getRiskLevelStatistics() {
    final stats = <String, int>{'YÜKSEK': 0, 'ORTA': 0, 'DÜŞÜK': 0};

    for (final report in _box.values) {
      final level = report.riskLevel.toUpperCase();
      if (stats.containsKey(level)) {
        stats[level] = (stats[level] ?? 0) + 1;
      }
    }

    return stats;
  }

  /// İstatistikler - Bu ay oluşturulan raporlar
  int getThisMonthReportsCount() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return _box.values
        .where((report) => report.timestamp.isAfter(startOfMonth) && report.timestamp.isBefore(endOfMonth))
        .length;
  }

  /// İstatistikler - Bu hafta oluşturulan raporlar
  int getThisWeekReportsCount() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekMidnight = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return _box.values.where((report) => report.timestamp.isAfter(startOfWeekMidnight)).length;
  }

  /// İstatistikler - Gönderilen email sayısı
  int getSentEmailsCount() {
    return _box.values.where((report) => report.emailSent).length;
  }
}
