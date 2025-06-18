// lib/data/providers.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neyese4/core/api/ai_service.dart';
import 'package:neyese4/core/api/dio_client.dart'; // dio_client importu
import 'package:neyese4/data/models/saved_recipe.dart';
import 'package:neyese4/data/repositories/product_repository.dart';
import 'package:neyese4/data/repositories/recipe_repository.dart';
import 'package:neyese4/data/repositories/saved_recipe_repository.dart';
import 'package:neyese4/data/models/pantry_item.dart';
import 'package:neyese4/data/repositories/pantry_repository.dart';


// --- API PROVIDER'LARI ---

final productRepositoryProvider = Provider((ref) => ProductRepository());


// GÜNCELLENDİ: Bu provider artık doğrudan Dio nesnesi yerine, DioClient sınıfının kendisini sağlar.
// Bu sayede DioClient'ın constructor'ı doğru şekilde çağrılır.
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

// GÜNCELLENDİ: Bu provider artık dioClientProvider'dan DioClient'ı alır ve içindeki .dio getter'ını kullanır.
final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SpoonacularRecipeRepository(dio: dioClient.dio);
});

final aiServiceProvider = Provider<AiService>((ref) {
  return AiService();
});

// --- YEREL VERİTABANI (HIVE) PROVIDER'LARI (Değişiklik yok) ---
// YENİ: Akıllı Kiler (Pantry) kutusunu sağlayan provider.
final pantryBoxProvider = Provider((ref) => Hive.box<PantryItem>(kPantryBoxName));


final savedRecipeRepositoryProvider = Provider<SavedRecipeRepository>((ref) {
  return SavedRecipeRepository();
});

final savedRecipesListProvider = Provider<List<SavedRecipe>>((ref) {
  ref.watch(savedRecipesStreamProvider);
  return ref.read(savedRecipeRepositoryProvider).getAllSavedRecipes();
});

final savedRecipesStreamProvider = StreamProvider.autoDispose<BoxEvent>((ref) {
  return ref.watch(savedRecipeRepositoryProvider).watchRecipes();
});