import 'package:freezed_annotation/freezed_annotation.dart';

// Bu dosyalar henüz mevcut değil, bir sonraki adımda kod üreteci tarafından oluşturulacak.
part 'recipe_suggestion.freezed.dart';
part 'recipe_suggestion.g.dart';

// Freezed kullanarak, API'den gelen öneri verisi için bir model oluşturuyoruz.
@freezed
class RecipeSuggestion with _$RecipeSuggestion {
  const factory RecipeSuggestion({
    // Spoonacular'dan gelen JSON verisindeki alan adlarıyla eşleşmeli.
    required int id,
    required String title,
    required String image,
  }) = _RecipeSuggestion;

  // JSON'dan bu modele dönüşüm yapacak fabrika metodunu tanımlıyoruz.
  factory RecipeSuggestion.fromJson(Map<String, dynamic> json) =>
      _$RecipeSuggestionFromJson(json);
}
