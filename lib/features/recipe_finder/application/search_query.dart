import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_query.freezed.dart';

@freezed
class SearchQuery with _$SearchQuery {
  const factory SearchQuery({
    required List<String> ingredients,
    String? diet,
    List<String>? intolerances,
    // YENİ EKLENDİ: Mutfak aletlerini arama kriterine ekliyoruz.
    List<String>? equipment,
  }) = _SearchQuery;
}
