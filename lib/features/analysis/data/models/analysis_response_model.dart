import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:safeguard_ai/features/analysis/domain/entities/analysis_entity.dart';

part 'analysis_response_model.freezed.dart';
part 'analysis_response_model.g.dart';

@freezed
class AnalysisResponseModel with _$AnalysisResponseModel {
  const factory AnalysisResponseModel({
    required bool success,
    required AnalysisData data,
  }) = _AnalysisResponseModel;

  factory AnalysisResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResponseModelFromJson(json);
}

@freezed
class AnalysisData with _$AnalysisData {
  const factory AnalysisData({
    required Analysis analysis,
    @JsonKey(name: 'report_draft') required ReportDraft reportDraft,
  }) = _AnalysisData;

  factory AnalysisData.fromJson(Map<String, dynamic> json) =>
      _$AnalysisDataFromJson(json);
}

@freezed
class Analysis with _$Analysis {
  const factory Analysis({
    @JsonKey(name: 'risk_level') required String riskLevel,
    required String category,
    required int confidence,
  }) = _Analysis;

  factory Analysis.fromJson(Map<String, dynamic> json) =>
      _$AnalysisFromJson(json);
}

@freezed
class ReportDraft with _$ReportDraft {
  const factory ReportDraft({
    @JsonKey(name: 'to_email') required String toEmail,
    required String subject,
    required String body,
    @JsonKey(name: 'recommended_action') required String recommendedAction,
  }) = _ReportDraft;

  factory ReportDraft.fromJson(Map<String, dynamic> json) =>
      _$ReportDraftFromJson(json);
}

// Extension for mapping to Entity
extension AnalysisResponseModelExtension on AnalysisResponseModel {
  AnalysisEntity toEntity() {
    return AnalysisEntity(
      riskLevel: data.analysis.riskLevel,
      category: data.analysis.category,
      confidence: data.analysis.confidence,
      reportEmail: data.reportDraft.toEmail,
      reportSubject: data.reportDraft.subject,
      reportBody: data.reportDraft.body,
      recommendedAction: data.reportDraft.recommendedAction,
    );
  }
}

