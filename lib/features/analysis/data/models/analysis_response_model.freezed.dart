// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnalysisResponseModel _$AnalysisResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _AnalysisResponseModel.fromJson(json);
}

/// @nodoc
mixin _$AnalysisResponseModel {
  bool get success => throw _privateConstructorUsedError;
  AnalysisData get data => throw _privateConstructorUsedError;

  /// Serializes this AnalysisResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalysisResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisResponseModelCopyWith<AnalysisResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisResponseModelCopyWith<$Res> {
  factory $AnalysisResponseModelCopyWith(
    AnalysisResponseModel value,
    $Res Function(AnalysisResponseModel) then,
  ) = _$AnalysisResponseModelCopyWithImpl<$Res, AnalysisResponseModel>;
  @useResult
  $Res call({bool success, AnalysisData data});

  $AnalysisDataCopyWith<$Res> get data;
}

/// @nodoc
class _$AnalysisResponseModelCopyWithImpl<
  $Res,
  $Val extends AnalysisResponseModel
>
    implements $AnalysisResponseModelCopyWith<$Res> {
  _$AnalysisResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalysisResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? data = null}) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as AnalysisData,
          )
          as $Val,
    );
  }

  /// Create a copy of AnalysisResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisDataCopyWith<$Res> get data {
    return $AnalysisDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalysisResponseModelImplCopyWith<$Res>
    implements $AnalysisResponseModelCopyWith<$Res> {
  factory _$$AnalysisResponseModelImplCopyWith(
    _$AnalysisResponseModelImpl value,
    $Res Function(_$AnalysisResponseModelImpl) then,
  ) = __$$AnalysisResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, AnalysisData data});

  @override
  $AnalysisDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$AnalysisResponseModelImplCopyWithImpl<$Res>
    extends
        _$AnalysisResponseModelCopyWithImpl<$Res, _$AnalysisResponseModelImpl>
    implements _$$AnalysisResponseModelImplCopyWith<$Res> {
  __$$AnalysisResponseModelImplCopyWithImpl(
    _$AnalysisResponseModelImpl _value,
    $Res Function(_$AnalysisResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalysisResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = null, Object? data = null}) {
    return _then(
      _$AnalysisResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as AnalysisData,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisResponseModelImpl implements _AnalysisResponseModel {
  const _$AnalysisResponseModelImpl({
    required this.success,
    required this.data,
  });

  factory _$AnalysisResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisResponseModelImplFromJson(json);

  @override
  final bool success;
  @override
  final AnalysisData data;

  @override
  String toString() {
    return 'AnalysisResponseModel(success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data);

  /// Create a copy of AnalysisResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisResponseModelImplCopyWith<_$AnalysisResponseModelImpl>
  get copyWith =>
      __$$AnalysisResponseModelImplCopyWithImpl<_$AnalysisResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisResponseModelImplToJson(this);
  }
}

abstract class _AnalysisResponseModel implements AnalysisResponseModel {
  const factory _AnalysisResponseModel({
    required final bool success,
    required final AnalysisData data,
  }) = _$AnalysisResponseModelImpl;

  factory _AnalysisResponseModel.fromJson(Map<String, dynamic> json) =
      _$AnalysisResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  AnalysisData get data;

  /// Create a copy of AnalysisResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisResponseModelImplCopyWith<_$AnalysisResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AnalysisData _$AnalysisDataFromJson(Map<String, dynamic> json) {
  return _AnalysisData.fromJson(json);
}

/// @nodoc
mixin _$AnalysisData {
  Analysis get analysis => throw _privateConstructorUsedError;
  @JsonKey(name: 'report_draft')
  ReportDraft get reportDraft => throw _privateConstructorUsedError;

  /// Serializes this AnalysisData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalysisData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisDataCopyWith<AnalysisData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisDataCopyWith<$Res> {
  factory $AnalysisDataCopyWith(
    AnalysisData value,
    $Res Function(AnalysisData) then,
  ) = _$AnalysisDataCopyWithImpl<$Res, AnalysisData>;
  @useResult
  $Res call({
    Analysis analysis,
    @JsonKey(name: 'report_draft') ReportDraft reportDraft,
  });

  $AnalysisCopyWith<$Res> get analysis;
  $ReportDraftCopyWith<$Res> get reportDraft;
}

/// @nodoc
class _$AnalysisDataCopyWithImpl<$Res, $Val extends AnalysisData>
    implements $AnalysisDataCopyWith<$Res> {
  _$AnalysisDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalysisData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? analysis = null, Object? reportDraft = null}) {
    return _then(
      _value.copyWith(
            analysis: null == analysis
                ? _value.analysis
                : analysis // ignore: cast_nullable_to_non_nullable
                      as Analysis,
            reportDraft: null == reportDraft
                ? _value.reportDraft
                : reportDraft // ignore: cast_nullable_to_non_nullable
                      as ReportDraft,
          )
          as $Val,
    );
  }

  /// Create a copy of AnalysisData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisCopyWith<$Res> get analysis {
    return $AnalysisCopyWith<$Res>(_value.analysis, (value) {
      return _then(_value.copyWith(analysis: value) as $Val);
    });
  }

  /// Create a copy of AnalysisData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReportDraftCopyWith<$Res> get reportDraft {
    return $ReportDraftCopyWith<$Res>(_value.reportDraft, (value) {
      return _then(_value.copyWith(reportDraft: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalysisDataImplCopyWith<$Res>
    implements $AnalysisDataCopyWith<$Res> {
  factory _$$AnalysisDataImplCopyWith(
    _$AnalysisDataImpl value,
    $Res Function(_$AnalysisDataImpl) then,
  ) = __$$AnalysisDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Analysis analysis,
    @JsonKey(name: 'report_draft') ReportDraft reportDraft,
  });

  @override
  $AnalysisCopyWith<$Res> get analysis;
  @override
  $ReportDraftCopyWith<$Res> get reportDraft;
}

/// @nodoc
class __$$AnalysisDataImplCopyWithImpl<$Res>
    extends _$AnalysisDataCopyWithImpl<$Res, _$AnalysisDataImpl>
    implements _$$AnalysisDataImplCopyWith<$Res> {
  __$$AnalysisDataImplCopyWithImpl(
    _$AnalysisDataImpl _value,
    $Res Function(_$AnalysisDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalysisData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? analysis = null, Object? reportDraft = null}) {
    return _then(
      _$AnalysisDataImpl(
        analysis: null == analysis
            ? _value.analysis
            : analysis // ignore: cast_nullable_to_non_nullable
                  as Analysis,
        reportDraft: null == reportDraft
            ? _value.reportDraft
            : reportDraft // ignore: cast_nullable_to_non_nullable
                  as ReportDraft,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisDataImpl implements _AnalysisData {
  const _$AnalysisDataImpl({
    required this.analysis,
    @JsonKey(name: 'report_draft') required this.reportDraft,
  });

  factory _$AnalysisDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisDataImplFromJson(json);

  @override
  final Analysis analysis;
  @override
  @JsonKey(name: 'report_draft')
  final ReportDraft reportDraft;

  @override
  String toString() {
    return 'AnalysisData(analysis: $analysis, reportDraft: $reportDraft)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisDataImpl &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis) &&
            (identical(other.reportDraft, reportDraft) ||
                other.reportDraft == reportDraft));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, analysis, reportDraft);

  /// Create a copy of AnalysisData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisDataImplCopyWith<_$AnalysisDataImpl> get copyWith =>
      __$$AnalysisDataImplCopyWithImpl<_$AnalysisDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisDataImplToJson(this);
  }
}

abstract class _AnalysisData implements AnalysisData {
  const factory _AnalysisData({
    required final Analysis analysis,
    @JsonKey(name: 'report_draft') required final ReportDraft reportDraft,
  }) = _$AnalysisDataImpl;

  factory _AnalysisData.fromJson(Map<String, dynamic> json) =
      _$AnalysisDataImpl.fromJson;

  @override
  Analysis get analysis;
  @override
  @JsonKey(name: 'report_draft')
  ReportDraft get reportDraft;

  /// Create a copy of AnalysisData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisDataImplCopyWith<_$AnalysisDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Analysis _$AnalysisFromJson(Map<String, dynamic> json) {
  return _Analysis.fromJson(json);
}

/// @nodoc
mixin _$Analysis {
  @JsonKey(name: 'risk_level')
  String get riskLevel => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  int get confidence => throw _privateConstructorUsedError;

  /// Serializes this Analysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Analysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisCopyWith<Analysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisCopyWith<$Res> {
  factory $AnalysisCopyWith(Analysis value, $Res Function(Analysis) then) =
      _$AnalysisCopyWithImpl<$Res, Analysis>;
  @useResult
  $Res call({
    @JsonKey(name: 'risk_level') String riskLevel,
    String category,
    int confidence,
  });
}

/// @nodoc
class _$AnalysisCopyWithImpl<$Res, $Val extends Analysis>
    implements $AnalysisCopyWith<$Res> {
  _$AnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Analysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riskLevel = null,
    Object? category = null,
    Object? confidence = null,
  }) {
    return _then(
      _value.copyWith(
            riskLevel: null == riskLevel
                ? _value.riskLevel
                : riskLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalysisImplCopyWith<$Res>
    implements $AnalysisCopyWith<$Res> {
  factory _$$AnalysisImplCopyWith(
    _$AnalysisImpl value,
    $Res Function(_$AnalysisImpl) then,
  ) = __$$AnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'risk_level') String riskLevel,
    String category,
    int confidence,
  });
}

/// @nodoc
class __$$AnalysisImplCopyWithImpl<$Res>
    extends _$AnalysisCopyWithImpl<$Res, _$AnalysisImpl>
    implements _$$AnalysisImplCopyWith<$Res> {
  __$$AnalysisImplCopyWithImpl(
    _$AnalysisImpl _value,
    $Res Function(_$AnalysisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Analysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riskLevel = null,
    Object? category = null,
    Object? confidence = null,
  }) {
    return _then(
      _$AnalysisImpl(
        riskLevel: null == riskLevel
            ? _value.riskLevel
            : riskLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisImpl implements _Analysis {
  const _$AnalysisImpl({
    @JsonKey(name: 'risk_level') required this.riskLevel,
    required this.category,
    required this.confidence,
  });

  factory _$AnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisImplFromJson(json);

  @override
  @JsonKey(name: 'risk_level')
  final String riskLevel;
  @override
  final String category;
  @override
  final int confidence;

  @override
  String toString() {
    return 'Analysis(riskLevel: $riskLevel, category: $category, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisImpl &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, riskLevel, category, confidence);

  /// Create a copy of Analysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisImplCopyWith<_$AnalysisImpl> get copyWith =>
      __$$AnalysisImplCopyWithImpl<_$AnalysisImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalysisImplToJson(this);
  }
}

abstract class _Analysis implements Analysis {
  const factory _Analysis({
    @JsonKey(name: 'risk_level') required final String riskLevel,
    required final String category,
    required final int confidence,
  }) = _$AnalysisImpl;

  factory _Analysis.fromJson(Map<String, dynamic> json) =
      _$AnalysisImpl.fromJson;

  @override
  @JsonKey(name: 'risk_level')
  String get riskLevel;
  @override
  String get category;
  @override
  int get confidence;

  /// Create a copy of Analysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisImplCopyWith<_$AnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportDraft _$ReportDraftFromJson(Map<String, dynamic> json) {
  return _ReportDraft.fromJson(json);
}

/// @nodoc
mixin _$ReportDraft {
  @JsonKey(name: 'to_email')
  String get toEmail => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'recommended_action')
  String get recommendedAction => throw _privateConstructorUsedError;

  /// Serializes this ReportDraft to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportDraftCopyWith<ReportDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportDraftCopyWith<$Res> {
  factory $ReportDraftCopyWith(
    ReportDraft value,
    $Res Function(ReportDraft) then,
  ) = _$ReportDraftCopyWithImpl<$Res, ReportDraft>;
  @useResult
  $Res call({
    @JsonKey(name: 'to_email') String toEmail,
    String subject,
    String body,
    @JsonKey(name: 'recommended_action') String recommendedAction,
  });
}

/// @nodoc
class _$ReportDraftCopyWithImpl<$Res, $Val extends ReportDraft>
    implements $ReportDraftCopyWith<$Res> {
  _$ReportDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toEmail = null,
    Object? subject = null,
    Object? body = null,
    Object? recommendedAction = null,
  }) {
    return _then(
      _value.copyWith(
            toEmail: null == toEmail
                ? _value.toEmail
                : toEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            subject: null == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            recommendedAction: null == recommendedAction
                ? _value.recommendedAction
                : recommendedAction // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportDraftImplCopyWith<$Res>
    implements $ReportDraftCopyWith<$Res> {
  factory _$$ReportDraftImplCopyWith(
    _$ReportDraftImpl value,
    $Res Function(_$ReportDraftImpl) then,
  ) = __$$ReportDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'to_email') String toEmail,
    String subject,
    String body,
    @JsonKey(name: 'recommended_action') String recommendedAction,
  });
}

/// @nodoc
class __$$ReportDraftImplCopyWithImpl<$Res>
    extends _$ReportDraftCopyWithImpl<$Res, _$ReportDraftImpl>
    implements _$$ReportDraftImplCopyWith<$Res> {
  __$$ReportDraftImplCopyWithImpl(
    _$ReportDraftImpl _value,
    $Res Function(_$ReportDraftImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toEmail = null,
    Object? subject = null,
    Object? body = null,
    Object? recommendedAction = null,
  }) {
    return _then(
      _$ReportDraftImpl(
        toEmail: null == toEmail
            ? _value.toEmail
            : toEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        subject: null == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        recommendedAction: null == recommendedAction
            ? _value.recommendedAction
            : recommendedAction // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportDraftImpl implements _ReportDraft {
  const _$ReportDraftImpl({
    @JsonKey(name: 'to_email') required this.toEmail,
    required this.subject,
    required this.body,
    @JsonKey(name: 'recommended_action') required this.recommendedAction,
  });

  factory _$ReportDraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportDraftImplFromJson(json);

  @override
  @JsonKey(name: 'to_email')
  final String toEmail;
  @override
  final String subject;
  @override
  final String body;
  @override
  @JsonKey(name: 'recommended_action')
  final String recommendedAction;

  @override
  String toString() {
    return 'ReportDraft(toEmail: $toEmail, subject: $subject, body: $body, recommendedAction: $recommendedAction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportDraftImpl &&
            (identical(other.toEmail, toEmail) || other.toEmail == toEmail) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.recommendedAction, recommendedAction) ||
                other.recommendedAction == recommendedAction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, toEmail, subject, body, recommendedAction);

  /// Create a copy of ReportDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportDraftImplCopyWith<_$ReportDraftImpl> get copyWith =>
      __$$ReportDraftImplCopyWithImpl<_$ReportDraftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportDraftImplToJson(this);
  }
}

abstract class _ReportDraft implements ReportDraft {
  const factory _ReportDraft({
    @JsonKey(name: 'to_email') required final String toEmail,
    required final String subject,
    required final String body,
    @JsonKey(name: 'recommended_action')
    required final String recommendedAction,
  }) = _$ReportDraftImpl;

  factory _ReportDraft.fromJson(Map<String, dynamic> json) =
      _$ReportDraftImpl.fromJson;

  @override
  @JsonKey(name: 'to_email')
  String get toEmail;
  @override
  String get subject;
  @override
  String get body;
  @override
  @JsonKey(name: 'recommended_action')
  String get recommendedAction;

  /// Create a copy of ReportDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportDraftImplCopyWith<_$ReportDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
