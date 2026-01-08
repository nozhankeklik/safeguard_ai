import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:safeguard_ai/features/analysis/data/models/report_hive_model.dart';

part 'history_state.freezed.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState.initial() = _Initial;
  const factory HistoryState.loading() = _Loading;
  const factory HistoryState.loaded({
    required List<ReportHiveModel> reports,
    String? currentFilter,
  }) = _Loaded;
  const factory HistoryState.empty() = _Empty;
  const factory HistoryState.failure(String message) = _Failure;
}
