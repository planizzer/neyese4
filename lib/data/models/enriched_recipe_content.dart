// lib/data/models/enriched_recipe_content.dart

import 'package:neyese4/data/models/ingredient_info.dart';
import 'package:neyese4/data/models/preparation_step.dart';

class EnrichedRecipeContent {
  // Temel Tarif Bilgileri
  final String title;
  final String imageUrl; // Bu alan provider tarafından doldurulur
  final int readyInMinutes;
  final String difficulty;
  final List<String> tags;

  // Detaylı İçerik
  final Map<String, String> estimatedNutrition;
  final List<String> requiredUtensils;
  final List<IngredientInfo> ingredients;
  final List<PreparationStep> preparationSteps;
  final List<String> chefTips;

  // Kişiselleştirilmiş Yapay Zeka Çıktıları
  final List<String> allergenWarnings;
  final List<String> dietaryWarnings;
  final List<String> substitutionSuggestions;

  EnrichedRecipeContent({
    required this.title,
    this.imageUrl = '',
    required this.readyInMinutes,
    required this.difficulty,
    required this.tags,
    required this.estimatedNutrition,
    required this.requiredUtensils,
    required this.ingredients,
    required this.preparationSteps,
    required this.chefTips,
    this.allergenWarnings = const [],
    this.dietaryWarnings = const [],
    this.substitutionSuggestions = const [],
  });

  // Gelen JSON'ı bu nesneye çevirmek için bir fabrika metodu.
  factory EnrichedRecipeContent.fromJson(Map<String, dynamic> json) {
    return EnrichedRecipeContent(
      title: json['turkish_title'] as String? ?? 'Başlık Yok',
      readyInMinutes: json['readyInMinutes'] as int? ?? 0,
      difficulty: json['difficulty'] as String? ?? 'Belirtilmemiş',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      estimatedNutrition: (json['estimated_nutrition'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value.toString())) ?? {},
      requiredUtensils: (json['required_utensils'] as List<dynamic>?)
          ?.map((e) => e.toString()).toList() ?? [],
      ingredients: (json['ingredients_tr'] as List<dynamic>?)
          ?.map((item) => IngredientInfo.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      preparationSteps: (json['preparation_steps'] as List<dynamic>?)
          ?.map((item) => PreparationStep.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      chefTips: (json['chef_tips'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],

      // Yeni kişiselleştirme alanlarını JSON'dan okuma
      allergenWarnings: (json['allergen_warnings'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      dietaryWarnings: (json['dietary_warnings'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      substitutionSuggestions: (json['substitution_suggestions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
  EnrichedRecipeContent copyWith({String? imageUrl}) {
    return EnrichedRecipeContent(
      title: title,
      imageUrl: imageUrl ?? this.imageUrl,
      readyInMinutes: readyInMinutes,
      difficulty: difficulty,
      tags: tags,
      estimatedNutrition: estimatedNutrition,
      requiredUtensils: requiredUtensils,
      ingredients: ingredients,
      preparationSteps: preparationSteps,
      chefTips: chefTips,
      allergenWarnings: allergenWarnings,
      dietaryWarnings: dietaryWarnings,
      substitutionSuggestions: substitutionSuggestions,
    );
  }
}