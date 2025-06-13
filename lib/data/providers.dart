import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neyese4/core/api/dio_client.dart';
import 'package:neyese4/data/models/saved_recipe.dart';
import 'package:neyese4/data/repositories/recipe_repository.dart';
import 'package:neyese4/data/repositories/saved_recipe_repository.dart';

// --- API PROVIDER'LARI (DEĞİŞİKLİK YOK) ---
final dioClientProvider = Provider<Dio>((ref) {
  return DioClient().dio;
});

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return SpoonacularRecipeRepository(dio: dio);
});


// --- YEREL VERİTABANI (HIVE) PROVIDER'LARI (YENİ EKLENDİ) ---

// 1. SavedRecipeRepository'mizin bir örneğini oluşturan Provider.
final savedRecipeRepositoryProvider = Provider<SavedRecipeRepository>((ref) {
  return SavedRecipeRepository();
});

// 2. Kaydedilmiş tariflerin listesini sunan Provider.
// Bu provider, alttaki StreamProvider'ı dinleyerek her zaman güncel listeyi tutar.
final savedRecipesListProvider = Provider<List<SavedRecipe>>((ref) {
  // Veritabanındaki değişiklikleri dinliyoruz.
  ref.watch(savedRecipesStreamProvider);
  // Ve en güncel listeyi repository'den alıp sunuyoruz.
  return ref.read(savedRecipeRepositoryProvider).getAllSavedRecipes();
});


// 3. Veritabanındaki değişiklikleri gerçek zamanlı olarak dinleyen StreamProvider.
// Bu provider'ın ana amacı, veritabanında bir değişiklik olduğunda (ekleme/silme)
// 'savedRecipesListProvider'ın yeniden tetiklenmesini ve güncellenmesini sağlamaktır.
final savedRecipesStreamProvider = StreamProvider<BoxEvent>((ref) {
  return ref.watch(savedRecipeRepositoryProvider).watchRecipes();
});
