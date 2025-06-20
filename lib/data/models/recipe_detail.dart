import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_detail.freezed.dart';
part 'recipe_detail.g.dart';

// Tarifin tüm detaylarını barındıran model.
@freezed
class RecipeDetail with _$RecipeDetail {
  const factory RecipeDetail({
    required int id,
    required String title,
    required String image,
    required int readyInMinutes, // Hazırlanma süresi
    required List<Ingredient> extendedIngredients, // Malzeme listesi
    required String instructions, // Hazırlanış talimatları (HTML olarak gelebilir)
    String? summary, // Tarif özeti (HTML olarak gelebilir)
  }) = _RecipeDetail;

  factory RecipeDetail.fromJson(Map<String, dynamic> json) =>
      _$RecipeDetailFromJson(json);
}

// Tarifin içindeki her bir malzeme için ayrı bir model.
@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required int id,
    required String name,
    required String original, // "1 cup of flour" gibi orijinal metin
    required double amount,
    required String unit,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}
