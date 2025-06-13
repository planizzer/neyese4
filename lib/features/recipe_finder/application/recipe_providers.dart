import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/data/models/recipe_detail.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/data/providers.dart';

// Bu provider'da değişiklik yok.
final randomRecipesProvider = FutureProvider.autoDispose<List<RecipeSuggestion>>((ref) {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  return recipeRepository.getRandomRecipes();
});

// Bu provider'da değişiklik yok.
final recipeDetailProvider = FutureProvider.autoDispose.family<RecipeDetail, int>((ref, recipeId) {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  return recipeRepository.getRecipeDetailById(recipeId);
});

// DÜZENLENDİ: Bu provider artık geçici bir state değil, doğrudan veritabanını kontrol ediyor.
// Bir tarifin ID'sini alıp, o ID'nin veritabanında kayıtlı olup olmadığını (true/false) döndürür.
final isRecipeSavedProvider = Provider.autoDispose.family<bool, int>((ref, recipeId) {
  // Veritabanındaki değişiklikleri dinliyoruz ki, bu provider her zaman güncel kalsın.
  ref.watch(savedRecipesStreamProvider);
  final repository = ref.watch(savedRecipeRepositoryProvider);
  return repository.isRecipeSaved(recipeId);
});
