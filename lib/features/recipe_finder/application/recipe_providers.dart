// lib/features/recipe_finder/application/recipe_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/data/models/enriched_recipe_content.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/data/models/user_preferences.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/recipe_finder/application/search_query.dart';

// --- ARAMA VE ÖNERİ PROVIDER'LARI (Değişiklik yok) ---
final randomRecipesProvider = FutureProvider.autoDispose<List<RecipeSuggestion>>((ref) {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  return recipeRepository.getRandomRecipes();
});

final recipesByIngredientsProvider =
FutureProvider.autoDispose.family<List<RecipeSuggestion>, SearchQuery>((ref, query) {
  if (query.ingredients.isEmpty) {
    return Future.value([]);
  }
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  return recipeRepository.findRecipesByIngredients(
    query.ingredients,
    UserPreferences(diet: query.diet, intolerances: query.intolerances),
  );
});


// --- TARİF DETAY SAYFASI İÇİN YENİ PROVIDER'LAR ---

// 1. Temel tarifi Spoonacular'dan çeken provider (dahili kullanım için)
final _recipeDetailProvider = FutureProvider.autoDispose.family((ref, int recipeId) {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  return recipeRepository.getRecipeDetailById(recipeId);
});

// 2. Spoonacular'dan tarifi alıp Gemini ile zenginleştiren BİRLEŞİK provider
// Arayüzümüz sadece bu provider'ı kullanacak.
final fullRecipeProvider = FutureProvider.autoDispose.family<EnrichedRecipeContent, int>((ref, recipeId) async {
  // Önce temel tarifi al
  final baseRecipe = await ref.watch(_recipeDetailProvider(recipeId).future);

  // Sonra bu tarifi AI servisine gönderip zenginleştirilmiş halini al
  final aiService = ref.watch(aiServiceProvider);
  final enrichedContentFromAI = await aiService.getEnrichedRecipeContent(baseRecipe);


  return EnrichedRecipeContent(
    imageUrl: baseRecipe.image, // Spoonacular'dan gelen orijinal resim URL'si
    title: enrichedContentFromAI.title,
    difficulty: enrichedContentFromAI.difficulty,
    readyInMinutes: enrichedContentFromAI.readyInMinutes,
    tags: enrichedContentFromAI.tags,
    estimatedNutrition: enrichedContentFromAI.estimatedNutrition,
    requiredUtensils: enrichedContentFromAI.requiredUtensils,
    ingredients: enrichedContentFromAI.ingredients,
    preparationSteps: enrichedContentFromAI.preparationSteps,
    chefTips: enrichedContentFromAI.chefTips,
  );
});


// 3. Bir tarifin kaydedilip kaydedilmediğini kontrol eden provider (Değişiklik yok)
final isRecipeSavedProvider = Provider.autoDispose.family<bool, int>((ref, recipeId) {
  ref.watch(savedRecipesStreamProvider);
  final repository = ref.watch(savedRecipeRepositoryProvider);
  return repository.isRecipeSaved(recipeId);
});