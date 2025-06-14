import 'package:dio/dio.dart';
import 'package:neyese4/data/models/recipe_detail.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/data/models/user_preferences.dart';

abstract class RecipeRepository {
  Future<List<RecipeSuggestion>> getRandomRecipes();
  Future<RecipeDetail> getRecipeDetailById(int id);
  Future<List<RecipeSuggestion>> findRecipesByIngredients(
      List<String> ingredients,
      UserPreferences preferences,
      );
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

  // ARAMA FONKSİYONU TAMAMEN GÜNCELLENDİ
  @override
  Future<List<RecipeSuggestion>> findRecipesByIngredients(
      List<String> ingredients,
      UserPreferences preferences,
      ) async {
    final ingredientsString = _translateIngredients(ingredients);

    final Map<String, dynamic> queryParameters = {
      // DÜZELTME: Parametre adını 'includeIngredients' olarak değiştirdik.
      'includeIngredients': ingredientsString,
      'number': 20,
    };

    if (preferences.diet != null) {
      queryParameters['diet'] = preferences.diet;
    }

    if (preferences.intolerances != null && preferences.intolerances!.isNotEmpty) {
      queryParameters['intolerances'] = preferences.intolerances!.join(',');
    }

    try {
      // DÜZELTME: API endpoint'ini '/recipes/complexSearch' olarak değiştirdik.
      final response = await dio.get(
        '/recipes/complexSearch',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        // DÜZELTME: complexSearch'in cevabı 'results' anahtarı altındadır.
        final List<dynamic> results = response.data['results'];
        return results.map((json) => RecipeSuggestion.fromJson(json)).toList();
      } else {
        throw 'API isteği başarısız oldu: ${response.statusCode}';
      }
    } on DioException catch (e) {
      throw 'API isteği sırasında bir hata oluştu: $e';
    } catch (e) {
      throw 'Beklenmedik bir hata oluştu: $e';
    }
  }
}
