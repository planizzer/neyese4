// lib/data/models/enriched_recipe_content.dart

import 'package:neyese4/data/models/ingredient_info.dart';
import 'package:neyese4/data/models/preparation_step.dart';

class EnrichedRecipeContent {
  final String imageUrl; // YENİ EKLENDİ
  final String title;
  final String difficulty;
  final List<String> tags;
  final Map<String, String> estimatedNutrition;
  final List<String> requiredUtensils;
  final List<IngredientInfo> ingredients;
  final List<PreparationStep> preparationSteps;
  final List<String> chefTips;
  final int readyInMinutes;

  EnrichedRecipeContent({
    required this.imageUrl, // YENİ EKLENDİ
    required this.title,
    required this.difficulty,
    required this.tags,
    required this.estimatedNutrition,
    required this.requiredUtensils,
    required this.ingredients,
    required this.preparationSteps,
    required this.chefTips,
    required this.readyInMinutes,
  });

  // Not: fromJson metodunu DEĞİŞTİRMİYORUZ çünkü imageUrl AI'dan gelmeyecek.
  factory EnrichedRecipeContent.fromJson(Map<String, dynamic> json) {
    return EnrichedRecipeContent(
      imageUrl: '', // Burası provider içinde doldurulacağı için boş kalabilir.
      title: json['turkish_title'] as String? ?? 'Başlık Yok',
      difficulty: json['difficulty'] as String? ?? 'Belirtilmemiş',
      readyInMinutes: json['readyInMinutes'] as int? ?? 0,
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
    );
  }
}