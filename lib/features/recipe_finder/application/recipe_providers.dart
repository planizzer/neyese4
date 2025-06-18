// lib/features/recipe_finder/application/recipe_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/data/models/enriched_recipe_content.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/data/models/user_preferences.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/recipe_finder/application/search_query.dart';

final randomRecipesProvider = FutureProvider.autoDispose<List<RecipeSuggestion>>((ref) async {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  final aiService = ref.watch(aiServiceProvider);

  // 1. Önce İngilizce başlıklarla tarifleri al
  final originalRecipes = await recipeRepository.getRandomRecipes();
  if (originalRecipes.isEmpty) {
    return [];
  }

  // 2. Sadece başlıkları bir listeye topla
  final englishTitles = originalRecipes.map((e) => e.title).toList();

  // 3. Tüm başlıkları tek seferde çeviri için AI'a gönder
  final turkishTitles = await aiService.translateRecipeTitles(englishTitles);

  // 4. Orijinal tarif listesini, çevrilmiş başlıklarla yeni bir listeye dönüştür
  if (originalRecipes.length == turkishTitles.length) {
    final translatedRecipes = <RecipeSuggestion>[];
    for (int i = 0; i < originalRecipes.length; i++) {
      translatedRecipes.add(
        originalRecipes[i].copyWith(title: turkishTitles[i]),
      );
    }
    return translatedRecipes;
  }

  // Çeviri sayısı tutmazsa, güvenli liman olarak orijinal listeyi döndür
  return originalRecipes;
});

// GÜNCELLENDİ: Bu provider artık arama sonuçlarını da Türkçeleştiriyor.
final searchResultsProvider =
FutureProvider.autoDispose.family<List<RecipeSuggestion>, SearchQuery>((ref, query) async {

  final recipeRepository = ref.watch(recipeRepositoryProvider);
  final aiService = ref.watch(aiServiceProvider);

  // 1. Önce İngilizce başlıklarla arama sonuçlarını al
  final originalRecipes = await recipeRepository.findRecipes(query);
  if (originalRecipes.isEmpty) {
    return [];
  }

  // 2. Sadece başlıkları bir listeye topla
  final englishTitles = originalRecipes.map((e) => e.title).toList();

  // 3. Tüm başlıkları tek seferde çeviri için AI'a gönder
  final turkishTitles = await aiService.translateRecipeTitles(englishTitles);

  // 4. Orijinal sonuçları, çevrilmiş başlıklarla yeni bir listeye dönüştür
  if (originalRecipes.length == turkishTitles.length) {
    final translatedRecipes = <RecipeSuggestion>[];
    for (int i = 0; i < originalRecipes.length; i++) {
      translatedRecipes.add(
        originalRecipes[i].copyWith(title: turkishTitles[i]),
      );
    }
    return translatedRecipes;
  }

  // Güvenli liman olarak orijinal listeyi döndür
  return originalRecipes;
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

// YENİ: Akşam yemeği önerileri için özel bir provider
final dinnerIdeasProvider = FutureProvider.autoDispose<List<RecipeSuggestion>>((ref) {
  // Akşam yemeği için 'ana yemek' tipinde bir arama yapıyoruz.
  const query = SearchQuery(type: 'main course');
  // Mevcut arama provider'ımızı bu sabit sorguyla tetikliyoruz.
  return ref.watch(searchResultsProvider(query).future);
});