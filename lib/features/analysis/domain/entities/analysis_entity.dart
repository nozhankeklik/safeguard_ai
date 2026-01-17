import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_entity.freezed.dart';

/// Domain Entity - Backend'den gelen analiz sonucu
@freezed
class AnalysisEntity with _$AnalysisEntity {
  const factory AnalysisEntity({
    required bool success,
    required String analysisText,
    required String riskLevel,
    List<String>? correctiveActions,
  }) = _AnalysisEntity;
}

