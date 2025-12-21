// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalysisResponseModelImpl _$$AnalysisResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$AnalysisResponseModelImpl(
  success: json['success'] as bool,
  data: AnalysisData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$AnalysisResponseModelImplToJson(
  _$AnalysisResponseModelImpl instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_$AnalysisDataImpl _$$AnalysisDataImplFromJson(Map<String, dynamic> json) =>
    _$AnalysisDataImpl(
      analysis: Analysis.fromJson(json['analysis'] as Map<String, dynamic>),
      reportDraft: ReportDraft.fromJson(
        json['report_draft'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$AnalysisDataImplToJson(_$AnalysisDataImpl instance) =>
    <String, dynamic>{
      'analysis': instance.analysis,
      'report_draft': instance.reportDraft,
    };

_$AnalysisImpl _$$AnalysisImplFromJson(Map<String, dynamic> json) =>
    _$AnalysisImpl(
      riskLevel: json['risk_level'] as String,
      category: json['category'] as String,
      confidence: (json['confidence'] as num).toInt(),
    );

Map<String, dynamic> _$$AnalysisImplToJson(_$AnalysisImpl instance) =>
    <String, dynamic>{
      'risk_level': instance.riskLevel,
      'category': instance.category,
      'confidence': instance.confidence,
    };

_$ReportDraftImpl _$$ReportDraftImplFromJson(Map<String, dynamic> json) =>
    _$ReportDraftImpl(
      toEmail: json['to_email'] as String,
      subject: json['subject'] as String,
      body: json['body'] as String,
      recommendedAction: json['recommended_action'] as String,
    );

Map<String, dynamic> _$$ReportDraftImplToJson(_$ReportDraftImpl instance) =>
    <String, dynamic>{
      'to_email': instance.toEmail,
      'subject': instance.subject,
      'body': instance.body,
      'recommended_action': instance.recommendedAction,
    };
