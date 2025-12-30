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
  String get analysis => throw _privateConstructorUsedError;
  @JsonKey(name: 'risk_level')
  String get riskLevel => throw _privateConstructorUsedError;

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
  $Res call({
    bool success,
    String analysis,
    @JsonKey(name: 'risk_level') String riskLevel,
  });
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
  $Res call({
    Object? success = null,
    Object? analysis = null,
    Object? riskLevel = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            analysis: null == analysis
                ? _value.analysis
                : analysis // ignore: cast_nullable_to_non_nullable
                      as String,
            riskLevel: null == riskLevel
                ? _value.riskLevel
                : riskLevel // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
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
  $Res call({
    bool success,
    String analysis,
    @JsonKey(name: 'risk_level') String riskLevel,
  });
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
  $Res call({
    Object? success = null,
    Object? analysis = null,
    Object? riskLevel = null,
  }) {
    return _then(
      _$AnalysisResponseModelImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        analysis: null == analysis
            ? _value.analysis
            : analysis // ignore: cast_nullable_to_non_nullable
                  as String,
        riskLevel: null == riskLevel
            ? _value.riskLevel
            : riskLevel // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalysisResponseModelImpl implements _AnalysisResponseModel {
  const _$AnalysisResponseModelImpl({
    required this.success,
    required this.analysis,
    @JsonKey(name: 'risk_level') required this.riskLevel,
  });

  factory _$AnalysisResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalysisResponseModelImplFromJson(json);

  @override
  final bool success;
  @override
  final String analysis;
  @override
  @JsonKey(name: 'risk_level')
  final String riskLevel;

  @override
  String toString() {
    return 'AnalysisResponseModel(success: $success, analysis: $analysis, riskLevel: $riskLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisResponseModelImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, analysis, riskLevel);

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
    required final String analysis,
    @JsonKey(name: 'risk_level') required final String riskLevel,
  }) = _$AnalysisResponseModelImpl;

  factory _AnalysisResponseModel.fromJson(Map<String, dynamic> json) =
      _$AnalysisResponseModelImpl.fromJson;

  @override
  bool get success;
  @override
  String get analysis;
  @override
  @JsonKey(name: 'risk_level')
  String get riskLevel;

  /// Create a copy of AnalysisResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisResponseModelImplCopyWith<_$AnalysisResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
