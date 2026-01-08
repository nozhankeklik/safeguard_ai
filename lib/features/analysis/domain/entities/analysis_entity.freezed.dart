// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AnalysisEntity {
  bool get success => throw _privateConstructorUsedError;
  String get analysisText => throw _privateConstructorUsedError;
  String get riskLevel => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AnalysisEntityCopyWith<AnalysisEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisEntityCopyWith<$Res> {
  factory $AnalysisEntityCopyWith(
          AnalysisEntity value, $Res Function(AnalysisEntity) then) =
      _$AnalysisEntityCopyWithImpl<$Res, AnalysisEntity>;
  @useResult
  $Res call({bool success, String analysisText, String riskLevel});
}

/// @nodoc
class _$AnalysisEntityCopyWithImpl<$Res, $Val extends AnalysisEntity>
    implements $AnalysisEntityCopyWith<$Res> {
  _$AnalysisEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? analysisText = null,
    Object? riskLevel = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      analysisText: null == analysisText
          ? _value.analysisText
          : analysisText // ignore: cast_nullable_to_non_nullable
              as String,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalysisEntityImplCopyWith<$Res>
    implements $AnalysisEntityCopyWith<$Res> {
  factory _$$AnalysisEntityImplCopyWith(_$AnalysisEntityImpl value,
          $Res Function(_$AnalysisEntityImpl) then) =
      __$$AnalysisEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String analysisText, String riskLevel});
}

/// @nodoc
class __$$AnalysisEntityImplCopyWithImpl<$Res>
    extends _$AnalysisEntityCopyWithImpl<$Res, _$AnalysisEntityImpl>
    implements _$$AnalysisEntityImplCopyWith<$Res> {
  __$$AnalysisEntityImplCopyWithImpl(
      _$AnalysisEntityImpl _value, $Res Function(_$AnalysisEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? analysisText = null,
    Object? riskLevel = null,
  }) {
    return _then(_$AnalysisEntityImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      analysisText: null == analysisText
          ? _value.analysisText
          : analysisText // ignore: cast_nullable_to_non_nullable
              as String,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AnalysisEntityImpl implements _AnalysisEntity {
  const _$AnalysisEntityImpl(
      {required this.success,
      required this.analysisText,
      required this.riskLevel});

  @override
  final bool success;
  @override
  final String analysisText;
  @override
  final String riskLevel;

  @override
  String toString() {
    return 'AnalysisEntity(success: $success, analysisText: $analysisText, riskLevel: $riskLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisEntityImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.analysisText, analysisText) ||
                other.analysisText == analysisText) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, success, analysisText, riskLevel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisEntityImplCopyWith<_$AnalysisEntityImpl> get copyWith =>
      __$$AnalysisEntityImplCopyWithImpl<_$AnalysisEntityImpl>(
          this, _$identity);
}

abstract class _AnalysisEntity implements AnalysisEntity {
  const factory _AnalysisEntity(
      {required final bool success,
      required final String analysisText,
      required final String riskLevel}) = _$AnalysisEntityImpl;

  @override
  bool get success;
  @override
  String get analysisText;
  @override
  String get riskLevel;
  @override
  @JsonKey(ignore: true)
  _$$AnalysisEntityImplCopyWith<_$AnalysisEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
