// lib/features/recipe_finder/application/search_query.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_query.freezed.dart';

@freezed
class SearchQuery with _$SearchQuery {
  const factory SearchQuery({
    String? query,
    List<String>? ingredients,
    String? diet,
    List<String>? intolerances,
    String? type,
    String? cuisine,
    int? maxReadyTime, // YENİ EKLENDİ
  }) = _SearchQuery;
}