import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/analysis_entity.dart';

part 'analysis_response_model.freezed.dart';
part 'analysis_response_model.g.dart';

/// Backend'den dönen response modeli
/// n8n webhook'undan gelen JSON yapısı:
/// {
///   "success": true,
///   "analysis": "Analiz metni...",
///   "risk_level": "YÜKSEK"
/// }
@freezed
class AnalysisResponseModel with _$AnalysisResponseModel {
  const factory AnalysisResponseModel({
    required bool success,
    required String analysis,
    @JsonKey(name: 'risk_level') required String riskLevel,
    @JsonKey(name: 'corrective_actions') List<String>? correctiveActions,
  }) = _AnalysisResponseModel;

  factory AnalysisResponseModel.fromJson(Map<String, dynamic> json) => _$AnalysisResponseModelFromJson(json);
}

// Extension for mapping to Entity
extension AnalysisResponseModelExtension on AnalysisResponseModel {
  AnalysisEntity toEntity() {
    return AnalysisEntity(
      success: success,
      analysisText: analysis,
      riskLevel: riskLevel,
      correctiveActions: correctiveActions,
    );
  }
}
