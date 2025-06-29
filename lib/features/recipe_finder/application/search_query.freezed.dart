// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchQuery {
  String? get query => throw _privateConstructorUsedError;
  List<String>? get ingredients => throw _privateConstructorUsedError;
  String? get diet => throw _privateConstructorUsedError;
  List<String>? get intolerances => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get cuisine => throw _privateConstructorUsedError;
  int? get maxReadyTime => throw _privateConstructorUsedError;

  /// Create a copy of SearchQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchQueryCopyWith<SearchQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchQueryCopyWith<$Res> {
  factory $SearchQueryCopyWith(
          SearchQuery value, $Res Function(SearchQuery) then) =
      _$SearchQueryCopyWithImpl<$Res, SearchQuery>;
  @useResult
  $Res call(
      {String? query,
      List<String>? ingredients,
      String? diet,
      List<String>? intolerances,
      String? type,
      String? cuisine,
      int? maxReadyTime});
}

/// @nodoc
class _$SearchQueryCopyWithImpl<$Res, $Val extends SearchQuery>
    implements $SearchQueryCopyWith<$Res> {
  _$SearchQueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? ingredients = freezed,
    Object? diet = freezed,
    Object? intolerances = freezed,
    Object? type = freezed,
    Object? cuisine = freezed,
    Object? maxReadyTime = freezed,
  }) {
    return _then(_value.copyWith(
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      ingredients: freezed == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      diet: freezed == diet
          ? _value.diet
          : diet // ignore: cast_nullable_to_non_nullable
              as String?,
      intolerances: freezed == intolerances
          ? _value.intolerances
          : intolerances // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      cuisine: freezed == cuisine
          ? _value.cuisine
          : cuisine // ignore: cast_nullable_to_non_nullable
              as String?,
      maxReadyTime: freezed == maxReadyTime
          ? _value.maxReadyTime
          : maxReadyTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchQueryImplCopyWith<$Res>
    implements $SearchQueryCopyWith<$Res> {
  factory _$$SearchQueryImplCopyWith(
          _$SearchQueryImpl value, $Res Function(_$SearchQueryImpl) then) =
      __$$SearchQueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? query,
      List<String>? ingredients,
      String? diet,
      List<String>? intolerances,
      String? type,
      String? cuisine,
      int? maxReadyTime});
}

/// @nodoc
class __$$SearchQueryImplCopyWithImpl<$Res>
    extends _$SearchQueryCopyWithImpl<$Res, _$SearchQueryImpl>
    implements _$$SearchQueryImplCopyWith<$Res> {
  __$$SearchQueryImplCopyWithImpl(
      _$SearchQueryImpl _value, $Res Function(_$SearchQueryImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? ingredients = freezed,
    Object? diet = freezed,
    Object? intolerances = freezed,
    Object? type = freezed,
    Object? cuisine = freezed,
    Object? maxReadyTime = freezed,
  }) {
    return _then(_$SearchQueryImpl(
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      ingredients: freezed == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      diet: freezed == diet
          ? _value.diet
          : diet // ignore: cast_nullable_to_non_nullable
              as String?,
      intolerances: freezed == intolerances
          ? _value._intolerances
          : intolerances // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      cuisine: freezed == cuisine
          ? _value.cuisine
          : cuisine // ignore: cast_nullable_to_non_nullable
              as String?,
      maxReadyTime: freezed == maxReadyTime
          ? _value.maxReadyTime
          : maxReadyTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$SearchQueryImpl implements _SearchQuery {
  const _$SearchQueryImpl(
      {this.query,
      final List<String>? ingredients,
      this.diet,
      final List<String>? intolerances,
      this.type,
      this.cuisine,
      this.maxReadyTime})
      : _ingredients = ingredients,
        _intolerances = intolerances;

  @override
  final String? query;
  final List<String>? _ingredients;
  @override
  List<String>? get ingredients {
    final value = _ingredients;
    if (value == null) return null;
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? diet;
  final List<String>? _intolerances;
  @override
  List<String>? get intolerances {
    final value = _intolerances;
    if (value == null) return null;
    if (_intolerances is EqualUnmodifiableListView) return _intolerances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? type;
  @override
  final String? cuisine;
  @override
  final int? maxReadyTime;

  @override
  String toString() {
    return 'SearchQuery(query: $query, ingredients: $ingredients, diet: $diet, intolerances: $intolerances, type: $type, cuisine: $cuisine, maxReadyTime: $maxReadyTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchQueryImpl &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            (identical(other.diet, diet) || other.diet == diet) &&
            const DeepCollectionEquality()
                .equals(other._intolerances, _intolerances) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.cuisine, cuisine) || other.cuisine == cuisine) &&
            (identical(other.maxReadyTime, maxReadyTime) ||
                other.maxReadyTime == maxReadyTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      query,
      const DeepCollectionEquality().hash(_ingredients),
      diet,
      const DeepCollectionEquality().hash(_intolerances),
      type,
      cuisine,
      maxReadyTime);

  /// Create a copy of SearchQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchQueryImplCopyWith<_$SearchQueryImpl> get copyWith =>
      __$$SearchQueryImplCopyWithImpl<_$SearchQueryImpl>(this, _$identity);
}

abstract class _SearchQuery implements SearchQuery {
  const factory _SearchQuery(
      {final String? query,
      final List<String>? ingredients,
      final String? diet,
      final List<String>? intolerances,
      final String? type,
      final String? cuisine,
      final int? maxReadyTime}) = _$SearchQueryImpl;

  @override
  String? get query;
  @override
  List<String>? get ingredients;
  @override
  String? get diet;
  @override
  List<String>? get intolerances;
  @override
  String? get type;
  @override
  String? get cuisine;
  @override
  int? get maxReadyTime;

  /// Create a copy of SearchQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchQueryImplCopyWith<_$SearchQueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
