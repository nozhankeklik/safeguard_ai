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
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AnalysisEntity {
  String get riskLevel => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  int get confidence => throw _privateConstructorUsedError;
  String get reportEmail => throw _privateConstructorUsedError;
  String get reportSubject => throw _privateConstructorUsedError;
  String get reportBody => throw _privateConstructorUsedError;
  String get recommendedAction => throw _privateConstructorUsedError;

  /// Create a copy of AnalysisEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalysisEntityCopyWith<AnalysisEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisEntityCopyWith<$Res> {
  factory $AnalysisEntityCopyWith(
    AnalysisEntity value,
    $Res Function(AnalysisEntity) then,
  ) = _$AnalysisEntityCopyWithImpl<$Res, AnalysisEntity>;
  @useResult
  $Res call({
    String riskLevel,
    String category,
    int confidence,
    String reportEmail,
    String reportSubject,
    String reportBody,
    String recommendedAction,
  });
}

/// @nodoc
class _$AnalysisEntityCopyWithImpl<$Res, $Val extends AnalysisEntity>
    implements $AnalysisEntityCopyWith<$Res> {
  _$AnalysisEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalysisEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riskLevel = null,
    Object? category = null,
    Object? confidence = null,
    Object? reportEmail = null,
    Object? reportSubject = null,
    Object? reportBody = null,
    Object? recommendedAction = null,
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
            reportEmail: null == reportEmail
                ? _value.reportEmail
                : reportEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            reportSubject: null == reportSubject
                ? _value.reportSubject
                : reportSubject // ignore: cast_nullable_to_non_nullable
                      as String,
            reportBody: null == reportBody
                ? _value.reportBody
                : reportBody // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AnalysisEntityImplCopyWith<$Res>
    implements $AnalysisEntityCopyWith<$Res> {
  factory _$$AnalysisEntityImplCopyWith(
    _$AnalysisEntityImpl value,
    $Res Function(_$AnalysisEntityImpl) then,
  ) = __$$AnalysisEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String riskLevel,
    String category,
    int confidence,
    String reportEmail,
    String reportSubject,
    String reportBody,
    String recommendedAction,
  });
}

/// @nodoc
class __$$AnalysisEntityImplCopyWithImpl<$Res>
    extends _$AnalysisEntityCopyWithImpl<$Res, _$AnalysisEntityImpl>
    implements _$$AnalysisEntityImplCopyWith<$Res> {
  __$$AnalysisEntityImplCopyWithImpl(
    _$AnalysisEntityImpl _value,
    $Res Function(_$AnalysisEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalysisEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riskLevel = null,
    Object? category = null,
    Object? confidence = null,
    Object? reportEmail = null,
    Object? reportSubject = null,
    Object? reportBody = null,
    Object? recommendedAction = null,
  }) {
    return _then(
      _$AnalysisEntityImpl(
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
        reportEmail: null == reportEmail
            ? _value.reportEmail
            : reportEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        reportSubject: null == reportSubject
            ? _value.reportSubject
            : reportSubject // ignore: cast_nullable_to_non_nullable
                  as String,
        reportBody: null == reportBody
            ? _value.reportBody
            : reportBody // ignore: cast_nullable_to_non_nullable
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

class _$AnalysisEntityImpl implements _AnalysisEntity {
  const _$AnalysisEntityImpl({
    required this.riskLevel,
    required this.category,
    required this.confidence,
    required this.reportEmail,
    required this.reportSubject,
    required this.reportBody,
    required this.recommendedAction,
  });

  @override
  final String riskLevel;
  @override
  final String category;
  @override
  final int confidence;
  @override
  final String reportEmail;
  @override
  final String reportSubject;
  @override
  final String reportBody;
  @override
  final String recommendedAction;

  @override
  String toString() {
    return 'AnalysisEntity(riskLevel: $riskLevel, category: $category, confidence: $confidence, reportEmail: $reportEmail, reportSubject: $reportSubject, reportBody: $reportBody, recommendedAction: $recommendedAction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalysisEntityImpl &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.reportEmail, reportEmail) ||
                other.reportEmail == reportEmail) &&
            (identical(other.reportSubject, reportSubject) ||
                other.reportSubject == reportSubject) &&
            (identical(other.reportBody, reportBody) ||
                other.reportBody == reportBody) &&
            (identical(other.recommendedAction, recommendedAction) ||
                other.recommendedAction == recommendedAction));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    riskLevel,
    category,
    confidence,
    reportEmail,
    reportSubject,
    reportBody,
    recommendedAction,
  );

  /// Create a copy of AnalysisEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalysisEntityImplCopyWith<_$AnalysisEntityImpl> get copyWith =>
      __$$AnalysisEntityImplCopyWithImpl<_$AnalysisEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _AnalysisEntity implements AnalysisEntity {
  const factory _AnalysisEntity({
    required final String riskLevel,
    required final String category,
    required final int confidence,
    required final String reportEmail,
    required final String reportSubject,
    required final String reportBody,
    required final String recommendedAction,
  }) = _$AnalysisEntityImpl;

  @override
  String get riskLevel;
  @override
  String get category;
  @override
  int get confidence;
  @override
  String get reportEmail;
  @override
  String get reportSubject;
  @override
  String get reportBody;
  @override
  String get recommendedAction;

  /// Create a copy of AnalysisEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalysisEntityImplCopyWith<_$AnalysisEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
