import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_event.freezed.dart';

@freezed
class HistoryEvent with _$HistoryEvent {
  const factory HistoryEvent.loadReports() = _LoadReports;
  const factory HistoryEvent.filterByRiskLevel(String? riskLevel) = _FilterByRiskLevel;
  const factory HistoryEvent.deleteReport(String id) = _DeleteReport;
  const factory HistoryEvent.deleteAllReports() = _DeleteAllReports;
}
