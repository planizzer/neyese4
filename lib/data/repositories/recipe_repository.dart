import 'package:dio/dio.dart';
import 'package:neyese4/data/models/recipe_detail.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/data/models/user_preferences.dart';

import '../../features/recipe_finder/application/search_query.dart';

abstract class RecipeRepository {
  Future<List<RecipeSuggestion>> getRandomRecipes();
  Future<RecipeDetail> getRecipeDetailById(int id);
  Future<List<RecipeSuggestion>> findRecipes(SearchQuery query);
}

class SpoonacularRecipeRepository implements RecipeRepository {
  final Dio dio;
  SpoonacularRecipeRepository({required this.dio});

  static const Map<String, String> _translationMap = {
    'tavuk': 'chicken', 'pirinç': 'rice', 'pirinc': 'rice', 'domates': 'tomato', 'soğan': 'onion', 'sogan': 'onion',
    'patates': 'potato', 'kıyma': 'minced meat', 'kiyma': 'minced meat', 'yumurta': 'egg', 'süt': 'milk', 'sut': 'milk',
    'peynir': 'cheese', 'un': 'flour', 'biber': 'pepper', 'patlıcan': 'eggplant', 'patlican': 'eggplant',
    'sarımsak': 'garlic', 'sarimsak': 'garlic', 'havuç': 'carrot', 'havuc': 'carrot', 'et': 'meat', 'makarna': 'pasta',
    'zeytinyağı': 'olive oil', 'zeytinyagi': 'olive oil', 'limon': 'lemon',
  };

  String _translateIngredients(List<String> ingredients) {
    return ingredients.map((turkishIngredient) {
      final lowercased = turkishIngredient.toLowerCase();
      return _translationMap[lowercased] ?? lowercased;
    }).join(',');
  }

  @override
  Future<List<RecipeSuggestion>> getRandomRecipes() async {
    // ... Bu fonksiyonda değişiklik yok ...
    try {
      final response = await dio.get('/recipes/random', queryParameters: {'number': 10});
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['recipes'];
        return results.map((json) => RecipeSuggestion.fromJson(json)).toList();
      } else { throw 'API isteği başarısız oldu: ${response.statusCode}'; }
    } catch (e) { throw 'Beklenmedik bir hata oluştu: $e'; }
  }

  @override
  Future<RecipeDetail> getRecipeDetailById(int id) async {
    // ... Bu fonksiyonda değişiklik yok ...
    try {
      final response = await dio.get('/recipes/$id/information');
      if (response.statusCode == 200) {
        return RecipeDetail.fromJson(response.data);
      } else { throw 'API isteği başarısız oldu: ${response.statusCode}'; }
    } catch (e) { throw 'Beklenmedik bir hata oluştu: $e'; }
  }

  // GÜNCELLENDİ: Metodun adı ve aldığı parametreler değişti
  @override
  Future<List<RecipeSuggestion>> findRecipes(SearchQuery query) async {
    final Map<String, dynamic> queryParameters = {
      'number': 20,
    };

    // Anahtar kelime ile arama
    if (query.query != null && query.query!.isNotEmpty) {
      queryParameters['query'] = query.query;
    }

    // Malzemelerle arama
    if (query.ingredients != null && query.ingredients!.isNotEmpty) {
      queryParameters['includeIngredients'] = _translateIngredients(query.ingredients!);
    }

    // Diyet, alerji ve diğer filtreler
    if (query.diet != null) { queryParameters['diet'] = query.diet; }
    if (query.intolerances != null && query.intolerances!.isNotEmpty) { queryParameters['intolerances'] = query.intolerances!.join(','); }
    if (query.type != null) { queryParameters['type'] = query.type; }
    if (query.cuisine != null) { queryParameters['cuisine'] = query.cuisine; }
    // YENİ EKLENDİ: maxReadyTime parametresini API isteğine ekliyoruz.
    if (query.maxReadyTime != null) {
      queryParameters['maxReadyTime'] = query.maxReadyTime;
    }

    try {
      final response = await dio.get('/recipes/complexSearch', queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => RecipeSuggestion.fromJson(json)).toList();
      } else {
        throw 'API isteği başarısız oldu: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Beklenmedik bir hata oluştu: $e';
    }
  }
}