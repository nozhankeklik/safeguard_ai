import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_entity.freezed.dart';

@freezed
class AnalysisEntity with _$AnalysisEntity {
  const factory AnalysisEntity({
    required String riskLevel,
    required String category,
    required int confidence,
    required String reportEmail,
    required String reportSubject,
    required String reportBody,
    required String recommendedAction,
  }) = _AnalysisEntity;
}

