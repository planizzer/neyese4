// lib/data/repositories/recipe_repository.dart

import 'package:dio/dio.dart';
import 'package:neyese4/core/api/ai_service.dart';
import 'package:neyese4/data/models/recipe_detail.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/features/recipe_finder/application/search_query.dart';

abstract class RecipeRepository {
  Future<List<RecipeSuggestion>> findRecipes(SearchQuery query);
  Future<List<RecipeSuggestion>> getRandomRecipes();
  Future<RecipeDetail> getRecipeDetailById(int id);
}

class SpoonacularRecipeRepository implements RecipeRepository {
  final Dio dio;
  final AiService aiService; // Yapay zeka servisini kullanmak için eklendi

  SpoonacularRecipeRepository({
    required this.dio,
    required this.aiService, // Constructor'a eklendi
  });

  @override
  Future<List<RecipeSuggestion>> getRandomRecipes() async {
    try {
      final response = await dio.get('/recipes/random', queryParameters: {'number': 10});
      final results = response.data['recipes'] as List;
      return results.map((json) => RecipeSuggestion.fromJson(json)).toList();
    } catch (e) {
      print('getRandomRecipes error: $e');
      return [];
    }
  }

  @override
  Future<RecipeDetail> getRecipeDetailById(int id) async {
    final response = await dio.get('/recipes/$id/information?includeNutrition=false');
    return RecipeDetail.fromJson(response.data);
  }

  @override
  Future<List<RecipeSuggestion>> findRecipes(SearchQuery query) async {
    try {
      final Map<String, dynamic> queryParameters = {'number': 20};

      // Anahtar kelime ile arama (Önce AI ile çevirip daha doğru sonuç alabiliriz)
      if (query.query != null && query.query!.isNotEmpty) {
        final translatedQuery = await aiService.translateIngredientsToEnglish([query.query!]);
        queryParameters['query'] = translatedQuery.first;
      }

      // Malzemelerle arama (AI ile çeviri)
      if (query.ingredients != null && query.ingredients!.isNotEmpty) {
        final translatedIngredients = await aiService.translateIngredientsToEnglish(query.ingredients!);
        queryParameters['includeIngredients'] = translatedIngredients.join(',');
        // Arama sıralamasını malzeme uyumuna göre yap.
        queryParameters['ranking'] = 2;
      }

      // Diğer filtreler
      if (query.diet != null) queryParameters['diet'] = query.diet;
      if (query.intolerances != null && query.intolerances!.isNotEmpty) {
        queryParameters['intolerances'] = query.intolerances!.join(',');
      }

      final response = await dio.get('/recipes/complexSearch', queryParameters: queryParameters);
      final results = response.data['results'] as List;
      return results.map((json) => RecipeSuggestion.fromJson(json)).toList();
    } catch (e) {
      print('findRecipes error: $e');
      return [];
    }
  }
}