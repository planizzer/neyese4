import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/data/models/enriched_recipe_content.dart';
import 'package:neyese4/data/models/recipe_detail.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/data/models/user_preferences.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/recipe_finder/application/search_query.dart';

// Günün önerileri için
final randomRecipesProvider = FutureProvider.autoDispose<List<RecipeSuggestion>>((ref) {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  return recipeRepository.getRandomRecipes();
});

// Ham tarif detayını API'den çekmek için
final recipeDetailProvider = FutureProvider.autoDispose.family<RecipeDetail, int>((ref, recipeId) {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  return recipeRepository.getRecipeDetailById(recipeId);
});

// Bir tarifin kayıtlı olup olmadığını kontrol etmek için
final isRecipeSavedProvider = Provider.autoDispose.family<bool, int>((ref, recipeId) {
  ref.watch(savedRecipesStreamProvider);
  final repository = ref.watch(savedRecipeRepositoryProvider);
  return repository.isRecipeSaved(recipeId);
});

// Malzemelere ve profil ayarlarına göre arama yapmak için
final recipesByIngredientsProvider =
FutureProvider.autoDispose.family<List<RecipeSuggestion>, SearchQuery>((ref, query) {
  if (query.ingredients.isEmpty) {
    return Future.value([]);
  }
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  return recipeRepository.findRecipesByIngredients(
    query.ingredients,
    UserPreferences(diet: query.diet, intolerances: query.intolerances, equipment: query.equipment),
  );
});

// DÜZENLENDİ: Bu provider artık ham tarifi alıp AI servisine göndererek zenginleştirilmiş içeriği getirir.
final enrichedRecipeProvider =
FutureProvider.autoDispose.family<EnrichedRecipeContent, RecipeDetail>((ref, recipe) {
  final aiService = ref.watch(aiServiceProvider);
  return aiService.getEnrichedRecipeContent(recipe);
});
