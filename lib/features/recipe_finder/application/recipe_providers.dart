import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/data/models/recipe_detail.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/data/providers.dart';

// ... Mevcut provider'lar (değişiklik yok) ...
final randomRecipesProvider = FutureProvider.autoDispose<List<RecipeSuggestion>>((ref) {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  return recipeRepository.getRandomRecipes();
});

final recipeDetailProvider = FutureProvider.autoDispose.family<RecipeDetail, int>((ref, recipeId) {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  return recipeRepository.getRecipeDetailById(recipeId);
});

final isRecipeSavedProvider = Provider.autoDispose.family<bool, int>((ref, recipeId) {
  ref.watch(savedRecipesStreamProvider);
  final repository = ref.watch(savedRecipeRepositoryProvider);
  return repository.isRecipeSaved(recipeId);
});


// YENİ EKLENEN ARAMA PROVIDER'I
// Dışarıdan bir liste malzeme alacağı için yine '.family' kullanıyoruz.
final recipesByIngredientsProvider =
FutureProvider.autoDispose.family<List<RecipeSuggestion>, List<String>>((ref, ingredients) {
  // Eğer malzeme listesi boşsa arama yapma, boş bir liste döndür.
  if (ingredients.isEmpty) {
    return Future.value([]);
  }
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  return recipeRepository.findRecipesByIngredients(ingredients);
});
