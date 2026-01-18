import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/analysis_entity.dart';

part 'analysis_state.freezed.dart';

@freezed
class AnalysisState with _$AnalysisState {
  const factory AnalysisState.initial() = _Initial;
  const factory AnalysisState.loading() = _Loading;
  const factory AnalysisState.success(AnalysisEntity entity) = _Success;
  const factory AnalysisState.failure(String message) = _Failure;
}
