// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecipeSuggestion _$RecipeSuggestionFromJson(Map<String, dynamic> json) {
  return _RecipeSuggestion.fromJson(json);
}

/// @nodoc
mixin _$RecipeSuggestion {
// Spoonacular'dan gelen JSON verisindeki alan adlarıyla eşleşmeli.
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;

  /// Serializes this RecipeSuggestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecipeSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeSuggestionCopyWith<RecipeSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeSuggestionCopyWith<$Res> {
  factory $RecipeSuggestionCopyWith(
          RecipeSuggestion value, $Res Function(RecipeSuggestion) then) =
      _$RecipeSuggestionCopyWithImpl<$Res, RecipeSuggestion>;
  @useResult
  $Res call({int id, String title, String image});
}

/// @nodoc
class _$RecipeSuggestionCopyWithImpl<$Res, $Val extends RecipeSuggestion>
    implements $RecipeSuggestionCopyWith<$Res> {
  _$RecipeSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecipeSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? image = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeSuggestionImplCopyWith<$Res>
    implements $RecipeSuggestionCopyWith<$Res> {
  factory _$$RecipeSuggestionImplCopyWith(_$RecipeSuggestionImpl value,
          $Res Function(_$RecipeSuggestionImpl) then) =
      __$$RecipeSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String title, String image});
}

/// @nodoc
class __$$RecipeSuggestionImplCopyWithImpl<$Res>
    extends _$RecipeSuggestionCopyWithImpl<$Res, _$RecipeSuggestionImpl>
    implements _$$RecipeSuggestionImplCopyWith<$Res> {
  __$$RecipeSuggestionImplCopyWithImpl(_$RecipeSuggestionImpl _value,
      $Res Function(_$RecipeSuggestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecipeSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? image = null,
  }) {
    return _then(_$RecipeSuggestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeSuggestionImpl implements _RecipeSuggestion {
  const _$RecipeSuggestionImpl(
      {required this.id, required this.title, required this.image});

  factory _$RecipeSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeSuggestionImplFromJson(json);

// Spoonacular'dan gelen JSON verisindeki alan adlarıyla eşleşmeli.
  @override
  final int id;
  @override
  final String title;
  @override
  final String image;

  @override
  String toString() {
    return 'RecipeSuggestion(id: $id, title: $title, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeSuggestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, image);

  /// Create a copy of RecipeSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeSuggestionImplCopyWith<_$RecipeSuggestionImpl> get copyWith =>
      __$$RecipeSuggestionImplCopyWithImpl<_$RecipeSuggestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeSuggestionImplToJson(
      this,
    );
  }
}

abstract class _RecipeSuggestion implements RecipeSuggestion {
  const factory _RecipeSuggestion(
      {required final int id,
      required final String title,
      required final String image}) = _$RecipeSuggestionImpl;

  factory _RecipeSuggestion.fromJson(Map<String, dynamic> json) =
      _$RecipeSuggestionImpl.fromJson;

// Spoonacular'dan gelen JSON verisindeki alan adlarıyla eşleşmeli.
  @override
  int get id;
  @override
  String get title;
  @override
  String get image;

  /// Create a copy of RecipeSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeSuggestionImplCopyWith<_$RecipeSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
