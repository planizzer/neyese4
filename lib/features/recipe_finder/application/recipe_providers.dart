import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/data/models/recipe_detail.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/recipe_finder/application/search_query.dart'; // Yeni modelimizi import ettik.
import 'package:neyese4/data/models/user_preferences.dart'; // Ekledik


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

// DÜZENLENDİ: Arama provider'ımız artık basit bir liste yerine,
// tüm arama kriterlerini içeren bir SearchQuery nesnesi alıyor.
final recipesByIngredientsProvider =
FutureProvider.autoDispose.family<List<RecipeSuggestion>, SearchQuery>((ref, query) {
  if (query.ingredients.isEmpty) {
    return Future.value([]);
  }

  // Repository'deki fonksiyonu yeni parametrelerle çağırıyoruz.
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  return recipeRepository.findRecipesByIngredients(
    query.ingredients,
    UserPreferences(diet: query.diet, intolerances: query.intolerances),
  );
});
// YENİ EKLENDİ: ZENGİNLEŞTİRİLMİŞ TARİF TALİMATLARI İÇİN PROVIDER
// Bu provider, bir tarif detayı nesnesi alır ve onun için Gemini'den
// zenginleştirilmiş metin talep eder.
final enrichedInstructionsProvider = FutureProvider.autoDispose.family<String, RecipeDetail>((ref, recipe) {
  // AI servisine erişiyoruz.
  final aiService = ref.watch(aiServiceProvider);
  // ve tarifi zenginleştirmesi için gönderiyoruz.
  return aiService.getEnrichedInstructions(recipe);
});
