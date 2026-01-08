// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AnalysisEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String imagePath) analyzeImage,
    required TResult Function() reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String imagePath)? analyzeImage,
    TResult? Function()? reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String imagePath)? analyzeImage,
    TResult Function()? reset,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AnalyzeImage value) analyzeImage,
    required TResult Function(_Reset value) reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AnalyzeImage value)? analyzeImage,
    TResult? Function(_Reset value)? reset,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AnalyzeImage value)? analyzeImage,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalysisEventCopyWith<$Res> {
  factory $AnalysisEventCopyWith(
          AnalysisEvent value, $Res Function(AnalysisEvent) then) =
      _$AnalysisEventCopyWithImpl<$Res, AnalysisEvent>;
}

/// @nodoc
class _$AnalysisEventCopyWithImpl<$Res, $Val extends AnalysisEvent>
    implements $AnalysisEventCopyWith<$Res> {
  _$AnalysisEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AnalyzeImageImplCopyWith<$Res> {
  factory _$$AnalyzeImageImplCopyWith(
          _$AnalyzeImageImpl value, $Res Function(_$AnalyzeImageImpl) then) =
      __$$AnalyzeImageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String imagePath});
}

/// @nodoc
class __$$AnalyzeImageImplCopyWithImpl<$Res>
    extends _$AnalysisEventCopyWithImpl<$Res, _$AnalyzeImageImpl>
    implements _$$AnalyzeImageImplCopyWith<$Res> {
  __$$AnalyzeImageImplCopyWithImpl(
      _$AnalyzeImageImpl _value, $Res Function(_$AnalyzeImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = null,
  }) {
    return _then(_$AnalyzeImageImpl(
      null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AnalyzeImageImpl implements _AnalyzeImage {
  const _$AnalyzeImageImpl(this.imagePath);

  @override
  final String imagePath;

  @override
  String toString() {
    return 'AnalysisEvent.analyzeImage(imagePath: $imagePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyzeImageImpl &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, imagePath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyzeImageImplCopyWith<_$AnalyzeImageImpl> get copyWith =>
      __$$AnalyzeImageImplCopyWithImpl<_$AnalyzeImageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String imagePath) analyzeImage,
    required TResult Function() reset,
  }) {
    return analyzeImage(imagePath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String imagePath)? analyzeImage,
    TResult? Function()? reset,
  }) {
    return analyzeImage?.call(imagePath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String imagePath)? analyzeImage,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (analyzeImage != null) {
      return analyzeImage(imagePath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AnalyzeImage value) analyzeImage,
    required TResult Function(_Reset value) reset,
  }) {
    return analyzeImage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AnalyzeImage value)? analyzeImage,
    TResult? Function(_Reset value)? reset,
  }) {
    return analyzeImage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AnalyzeImage value)? analyzeImage,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (analyzeImage != null) {
      return analyzeImage(this);
    }
    return orElse();
  }
}

abstract class _AnalyzeImage implements AnalysisEvent {
  const factory _AnalyzeImage(final String imagePath) = _$AnalyzeImageImpl;

  String get imagePath;
  @JsonKey(ignore: true)
  _$$AnalyzeImageImplCopyWith<_$AnalyzeImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResetImplCopyWith<$Res> {
  factory _$$ResetImplCopyWith(
          _$ResetImpl value, $Res Function(_$ResetImpl) then) =
      __$$ResetImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResetImplCopyWithImpl<$Res>
    extends _$AnalysisEventCopyWithImpl<$Res, _$ResetImpl>
    implements _$$ResetImplCopyWith<$Res> {
  __$$ResetImplCopyWithImpl(
      _$ResetImpl _value, $Res Function(_$ResetImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ResetImpl implements _Reset {
  const _$ResetImpl();

  @override
  String toString() {
    return 'AnalysisEvent.reset()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResetImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String imagePath) analyzeImage,
    required TResult Function() reset,
  }) {
    return reset();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String imagePath)? analyzeImage,
    TResult? Function()? reset,
  }) {
    return reset?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String imagePath)? analyzeImage,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AnalyzeImage value) analyzeImage,
    required TResult Function(_Reset value) reset,
  }) {
    return reset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AnalyzeImage value)? analyzeImage,
    TResult? Function(_Reset value)? reset,
  }) {
    return reset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AnalyzeImage value)? analyzeImage,
    TResult Function(_Reset value)? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset(this);
    }
    return orElse();
  }
}

abstract class _Reset implements AnalysisEvent {
  const factory _Reset() = _$ResetImpl;
}
