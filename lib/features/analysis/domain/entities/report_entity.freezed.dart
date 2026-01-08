// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReportEntity {
  AnalysisEntity get analysis => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get emailSubject => throw _privateConstructorUsedError;
  String get emailBody => throw _privateConstructorUsedError;
  List<String> get recipients => throw _privateConstructorUsedError;
  List<String> get ccRecipients => throw _privateConstructorUsedError;
  List<String> get bccRecipients => throw _privateConstructorUsedError;
  bool get saveToGoogleDocs => throw _privateConstructorUsedError;
  bool get generatePdf => throw _privateConstructorUsedError;
  bool get createFollowUp => throw _privateConstructorUsedError;

  /// Create a copy of ReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportEntityCopyWith<ReportEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportEntityCopyWith<$Res> {
  factory $ReportEntityCopyWith(
    ReportEntity value,
    $Res Function(ReportEntity) then,
  ) = _$ReportEntityCopyWithImpl<$Res, ReportEntity>;
  @useResult
  $Res call({
    AnalysisEntity analysis,
    String imagePath,
    DateTime timestamp,
    String emailSubject,
    String emailBody,
    List<String> recipients,
    List<String> ccRecipients,
    List<String> bccRecipients,
    bool saveToGoogleDocs,
    bool generatePdf,
    bool createFollowUp,
  });

  $AnalysisEntityCopyWith<$Res> get analysis;
}

/// @nodoc
class _$ReportEntityCopyWithImpl<$Res, $Val extends ReportEntity>
    implements $ReportEntityCopyWith<$Res> {
  _$ReportEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? analysis = null,
    Object? imagePath = null,
    Object? timestamp = null,
    Object? emailSubject = null,
    Object? emailBody = null,
    Object? recipients = null,
    Object? ccRecipients = null,
    Object? bccRecipients = null,
    Object? saveToGoogleDocs = null,
    Object? generatePdf = null,
    Object? createFollowUp = null,
  }) {
    return _then(
      _value.copyWith(
            analysis: null == analysis
                ? _value.analysis
                : analysis // ignore: cast_nullable_to_non_nullable
                      as AnalysisEntity,
            imagePath: null == imagePath
                ? _value.imagePath
                : imagePath // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            emailSubject: null == emailSubject
                ? _value.emailSubject
                : emailSubject // ignore: cast_nullable_to_non_nullable
                      as String,
            emailBody: null == emailBody
                ? _value.emailBody
                : emailBody // ignore: cast_nullable_to_non_nullable
                      as String,
            recipients: null == recipients
                ? _value.recipients
                : recipients // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            ccRecipients: null == ccRecipients
                ? _value.ccRecipients
                : ccRecipients // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            bccRecipients: null == bccRecipients
                ? _value.bccRecipients
                : bccRecipients // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            saveToGoogleDocs: null == saveToGoogleDocs
                ? _value.saveToGoogleDocs
                : saveToGoogleDocs // ignore: cast_nullable_to_non_nullable
                      as bool,
            generatePdf: null == generatePdf
                ? _value.generatePdf
                : generatePdf // ignore: cast_nullable_to_non_nullable
                      as bool,
            createFollowUp: null == createFollowUp
                ? _value.createFollowUp
                : createFollowUp // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of ReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalysisEntityCopyWith<$Res> get analysis {
    return $AnalysisEntityCopyWith<$Res>(_value.analysis, (value) {
      return _then(_value.copyWith(analysis: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReportEntityImplCopyWith<$Res>
    implements $ReportEntityCopyWith<$Res> {
  factory _$$ReportEntityImplCopyWith(
    _$ReportEntityImpl value,
    $Res Function(_$ReportEntityImpl) then,
  ) = __$$ReportEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AnalysisEntity analysis,
    String imagePath,
    DateTime timestamp,
    String emailSubject,
    String emailBody,
    List<String> recipients,
    List<String> ccRecipients,
    List<String> bccRecipients,
    bool saveToGoogleDocs,
    bool generatePdf,
    bool createFollowUp,
  });

  @override
  $AnalysisEntityCopyWith<$Res> get analysis;
}

/// @nodoc
class __$$ReportEntityImplCopyWithImpl<$Res>
    extends _$ReportEntityCopyWithImpl<$Res, _$ReportEntityImpl>
    implements _$$ReportEntityImplCopyWith<$Res> {
  __$$ReportEntityImplCopyWithImpl(
    _$ReportEntityImpl _value,
    $Res Function(_$ReportEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? analysis = null,
    Object? imagePath = null,
    Object? timestamp = null,
    Object? emailSubject = null,
    Object? emailBody = null,
    Object? recipients = null,
    Object? ccRecipients = null,
    Object? bccRecipients = null,
    Object? saveToGoogleDocs = null,
    Object? generatePdf = null,
    Object? createFollowUp = null,
  }) {
    return _then(
      _$ReportEntityImpl(
        analysis: null == analysis
            ? _value.analysis
            : analysis // ignore: cast_nullable_to_non_nullable
                  as AnalysisEntity,
        imagePath: null == imagePath
            ? _value.imagePath
            : imagePath // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        emailSubject: null == emailSubject
            ? _value.emailSubject
            : emailSubject // ignore: cast_nullable_to_non_nullable
                  as String,
        emailBody: null == emailBody
            ? _value.emailBody
            : emailBody // ignore: cast_nullable_to_non_nullable
                  as String,
        recipients: null == recipients
            ? _value._recipients
            : recipients // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        ccRecipients: null == ccRecipients
            ? _value._ccRecipients
            : ccRecipients // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        bccRecipients: null == bccRecipients
            ? _value._bccRecipients
            : bccRecipients // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        saveToGoogleDocs: null == saveToGoogleDocs
            ? _value.saveToGoogleDocs
            : saveToGoogleDocs // ignore: cast_nullable_to_non_nullable
                  as bool,
        generatePdf: null == generatePdf
            ? _value.generatePdf
            : generatePdf // ignore: cast_nullable_to_non_nullable
                  as bool,
        createFollowUp: null == createFollowUp
            ? _value.createFollowUp
            : createFollowUp // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ReportEntityImpl implements _ReportEntity {
  const _$ReportEntityImpl({
    required this.analysis,
    required this.imagePath,
    required this.timestamp,
    required this.emailSubject,
    required this.emailBody,
    required final List<String> recipients,
    final List<String> ccRecipients = const [],
    final List<String> bccRecipients = const [],
    this.saveToGoogleDocs = false,
    this.generatePdf = false,
    this.createFollowUp = false,
  }) : _recipients = recipients,
       _ccRecipients = ccRecipients,
       _bccRecipients = bccRecipients;

  @override
  final AnalysisEntity analysis;
  @override
  final String imagePath;
  @override
  final DateTime timestamp;
  @override
  final String emailSubject;
  @override
  final String emailBody;
  final List<String> _recipients;
  @override
  List<String> get recipients {
    if (_recipients is EqualUnmodifiableListView) return _recipients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recipients);
  }

  final List<String> _ccRecipients;
  @override
  @JsonKey()
  List<String> get ccRecipients {
    if (_ccRecipients is EqualUnmodifiableListView) return _ccRecipients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ccRecipients);
  }

  final List<String> _bccRecipients;
  @override
  @JsonKey()
  List<String> get bccRecipients {
    if (_bccRecipients is EqualUnmodifiableListView) return _bccRecipients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bccRecipients);
  }

  @override
  @JsonKey()
  final bool saveToGoogleDocs;
  @override
  @JsonKey()
  final bool generatePdf;
  @override
  @JsonKey()
  final bool createFollowUp;

  @override
  String toString() {
    return 'ReportEntity(analysis: $analysis, imagePath: $imagePath, timestamp: $timestamp, emailSubject: $emailSubject, emailBody: $emailBody, recipients: $recipients, ccRecipients: $ccRecipients, bccRecipients: $bccRecipients, saveToGoogleDocs: $saveToGoogleDocs, generatePdf: $generatePdf, createFollowUp: $createFollowUp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportEntityImpl &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.emailSubject, emailSubject) ||
                other.emailSubject == emailSubject) &&
            (identical(other.emailBody, emailBody) ||
                other.emailBody == emailBody) &&
            const DeepCollectionEquality().equals(
              other._recipients,
              _recipients,
            ) &&
            const DeepCollectionEquality().equals(
              other._ccRecipients,
              _ccRecipients,
            ) &&
            const DeepCollectionEquality().equals(
              other._bccRecipients,
              _bccRecipients,
            ) &&
            (identical(other.saveToGoogleDocs, saveToGoogleDocs) ||
                other.saveToGoogleDocs == saveToGoogleDocs) &&
            (identical(other.generatePdf, generatePdf) ||
                other.generatePdf == generatePdf) &&
            (identical(other.createFollowUp, createFollowUp) ||
                other.createFollowUp == createFollowUp));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    analysis,
    imagePath,
    timestamp,
    emailSubject,
    emailBody,
    const DeepCollectionEquality().hash(_recipients),
    const DeepCollectionEquality().hash(_ccRecipients),
    const DeepCollectionEquality().hash(_bccRecipients),
    saveToGoogleDocs,
    generatePdf,
    createFollowUp,
  );

  /// Create a copy of ReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportEntityImplCopyWith<_$ReportEntityImpl> get copyWith =>
      __$$ReportEntityImplCopyWithImpl<_$ReportEntityImpl>(this, _$identity);
}

abstract class _ReportEntity implements ReportEntity {
  const factory _ReportEntity({
    required final AnalysisEntity analysis,
    required final String imagePath,
    required final DateTime timestamp,
    required final String emailSubject,
    required final String emailBody,
    required final List<String> recipients,
    final List<String> ccRecipients,
    final List<String> bccRecipients,
    final bool saveToGoogleDocs,
    final bool generatePdf,
    final bool createFollowUp,
  }) = _$ReportEntityImpl;

  @override
  AnalysisEntity get analysis;
  @override
  String get imagePath;
  @override
  DateTime get timestamp;
  @override
  String get emailSubject;
  @override
  String get emailBody;
  @override
  List<String> get recipients;
  @override
  List<String> get ccRecipients;
  @override
  List<String> get bccRecipients;
  @override
  bool get saveToGoogleDocs;
  @override
  bool get generatePdf;
  @override
  bool get createFollowUp;

  /// Create a copy of ReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportEntityImplCopyWith<_$ReportEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
