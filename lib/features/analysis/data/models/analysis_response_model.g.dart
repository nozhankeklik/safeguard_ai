// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalysisResponseModelImpl _$$AnalysisResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AnalysisResponseModelImpl(
      success: json['success'] as bool,
      analysis: json['analysis'] as String,
      riskLevel: json['risk_level'] as String,
      correctiveActions: (json['corrective_actions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$AnalysisResponseModelImplToJson(
        _$AnalysisResponseModelImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'analysis': instance.analysis,
      'risk_level': instance.riskLevel,
      'corrective_actions': instance.correctiveActions,
    };
