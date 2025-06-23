// lib/data/providers.dart


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neyese4/core/api/ai_service.dart';
import 'package:neyese4/core/api/dio_client.dart';
import 'package:neyese4/data/models/enriched_recipe_content.dart';
import 'package:neyese4/data/models/pantry_item.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/data/models/saved_recipe.dart';
import 'package:neyese4/data/repositories/pantry_repository.dart';
import 'package:neyese4/data/repositories/product_repository.dart';
import 'package:neyese4/data/repositories/recipe_repository.dart';
import 'package:neyese4/features/auth/application/auth_service.dart';
import 'package:neyese4/data/repositories/firestore_repository.dart';
import 'package:neyese4/data/models/user_preferences.dart';
import 'package:neyese4/data/repositories/user_preferences_repository.dart';
import '../features/recipe_finder/application/search_query.dart';

// --- AUTHENTICATION ---
// AuthService sınıfımızın bir örneğini uygulama genelinde kullanılabilir hale getirir.
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Kullanıcının giriş/çıkış durumundaki değişiklikleri anlık olarak dinler.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});


// --- API SERVİSLERİ ---
final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return SpoonacularRecipeRepository(
    dio: ref.watch(dioClientProvider).dio,
    aiService: ref.watch(aiServiceProvider), // Bu satır çok önemli!
  );
});

final aiServiceProvider = Provider<AiService>((ref) => AiService());

final productRepositoryProvider = Provider((ref) => ProductRepository());


// --- TARİF GETİRME ---
final randomRecipesProvider = FutureProvider.autoDispose<List<RecipeSuggestion>>((ref) async {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  final aiService = ref.watch(aiServiceProvider);
  final originalRecipes = await recipeRepository.getRandomRecipes();
  if (originalRecipes.isEmpty) return [];
  final englishTitles = originalRecipes.map((e) => e.title).toList();
  final turkishTitles = await aiService.translateRecipeTitles(englishTitles);
  if (originalRecipes.length == turkishTitles.length) {
    return [for (int i = 0; i < originalRecipes.length; i++) originalRecipes[i].copyWith(title: turkishTitles[i])];
  }
  return originalRecipes;
});

final searchResultsProvider = FutureProvider.autoDispose.family<List<RecipeSuggestion>, SearchQuery>((ref, query) async {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  final aiService = ref.watch(aiServiceProvider);
  final originalRecipes = await recipeRepository.findRecipes(query);
  if (originalRecipes.isEmpty) return [];
  final englishTitles = originalRecipes.map((e) => e.title).toList();
  final turkishTitles = await aiService.translateRecipeTitles(englishTitles);
  if (originalRecipes.length == turkishTitles.length) {
    return [for (int i = 0; i < originalRecipes.length; i++) originalRecipes[i].copyWith(title: turkishTitles[i])];
  }
  return originalRecipes;
});

final _recipeDetailProvider = FutureProvider.autoDispose.family((ref, int recipeId) {
  final recipeRepository = ref.watch(recipeRepositoryProvider);
  return recipeRepository.getRecipeDetailById(recipeId);
});

final fullRecipeProvider = FutureProvider.autoDispose.family<EnrichedRecipeContent, int>((ref, recipeId) async {
  // 1. Gerekli tüm bilgileri diğer provider'lardan topluyoruz.
  final baseRecipe = await ref.watch(_recipeDetailProvider(recipeId).future);
  final userPreferences = ref.watch(userPreferencesProvider);
  final pantryItems = ref.watch(pantryBoxProvider).values.map((e) => e.productName).toList();

  // TODO: Porsiyon bilgisini ileride IngredientsCard'dan dinamik olarak alacağız.
  // Şimdilik, orijinal porsiyonu hedef porsiyon olarak kabul ediyoruz.
  final targetServings = baseRecipe.servings;

  // 2. AiService'i çağırırken artık tüm bu kişisel bilgileri gönderiyoruz.
  final aiService = ref.watch(aiServiceProvider);
  final enrichedContent = await aiService.getEnrichedRecipeContent(
    recipe: baseRecipe,
    targetServings: targetServings,
    userPreferences: userPreferences,
    pantryIngredients: pantryItems,
  );

  // 3. AI'dan gelen içeriği, API'den gelen orijinal resim URL'i ile birleştiriyoruz.
  return enrichedContent.copyWith(imageUrl: baseRecipe.image);
});

final dinnerIdeasProvider = FutureProvider.autoDispose<List<RecipeSuggestion>>((ref) {
  const query = SearchQuery(type: 'main course');
  return ref.watch(searchResultsProvider(query).future);
});


// --- VERİTABANI (FIRESTORE & HIVE) ---

// KİLER (HIVE)
final pantryBoxProvider = Provider((ref) => Hive.box<PantryItem>(kPantryBoxName));

// KAYDEDİLEN TARİFLER (FIRESTORE)
final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository();
});

// Bir tarifin kayıtlı olup olmadığını KONTROL EDEN provider
final isRecipeSavedProvider = FutureProvider.autoDispose.family<bool, int>((ref, recipeId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Future.value(false);
  return ref.watch(firestoreRepositoryProvider).isRecipeSaved(recipeId);
});

// Kaydedilen tariflerin LİSTESİNİ anlık getiren provider
final savedRecipesStreamProvider = StreamProvider.autoDispose<List<SavedRecipe>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(firestoreRepositoryProvider).getSavedRecipesStream();
});


// --- KULLANICI PROFİLİ VE TERCİHLERİ ---

// KULLANICI TERCİHLERİ (HIVE)
final userPreferencesRepositoryProvider = Provider<UserPreferencesRepository>((ref) {
  return UserPreferencesRepository();
});

final userPreferencesStreamProvider = StreamProvider.autoDispose<BoxEvent>((ref) {
  return ref.watch(userPreferencesRepositoryProvider).watchPreferences();
});

final userPreferencesProvider = StateProvider.autoDispose<UserPreferences>((ref) {
  ref.watch(userPreferencesStreamProvider);
  return ref.read(userPreferencesRepositoryProvider).getPreferences();
});

// OYUNLAŞTIRMA (XP PUANI)
final userXpProvider = StateProvider<int>((ref) => 0);