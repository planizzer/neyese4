import 'package:dio/dio.dart';
import 'package:neyese4/data/models/recipe_detail.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';

// Sözleşmemizde bir değişiklik yok.
abstract class RecipeRepository {
  Future<List<RecipeSuggestion>> getRandomRecipes();
  Future<RecipeDetail> getRecipeDetailById(int id);
  Future<List<RecipeSuggestion>> findRecipesByIngredients(List<String> ingredients);
}

class SpoonacularRecipeRepository implements RecipeRepository {
  final Dio dio;
  SpoonacularRecipeRepository({required this.dio});

  // YENİ EKLENDİ: Basit bir Türkçe-İngilizce çeviri sözlüğü.
  // Bu listeyi zamanla genişletebiliriz.
  static const Map<String, String> _translationMap = {
    'tavuk': 'chicken',
    'pirinç': 'rice',
    'pirinc': 'rice',
    'domates': 'tomato',
    'soğan': 'onion',
    'sogan': 'onion',
    'patates': 'potato',
    'kıyma': 'minced meat',
    'kiyma': 'minced meat',
    'yumurta': 'egg',
    'süt': 'milk',
    'sut': 'milk',
    'peynir': 'cheese',
    'un': 'flour',
    'biber': 'pepper',
    'patlıcan': 'eggplant',
    'patlican': 'eggplant',
    'sarımsak': 'garlic',
    'sarimsak': 'garlic',
    'havuç': 'carrot',
    'havuc': 'carrot',
    'et': 'meat',
    'makarna': 'pasta',
    'zeytinyağı': 'olive oil',
    'zeytinyagi': 'olive oil',
    'limon': 'lemon',
  };

  // YENİ EKLENDİ: Gelen malzemeleri çeviren yardımcı fonksiyon.
  String _translateIngredients(List<String> ingredients) {
    return ingredients.map((turkishIngredient) {
      // Malzemeyi küçük harfe çevirip sözlükte arıyoruz.
      final lowercased = turkishIngredient.toLowerCase();
      // Eğer sözlükte varsa İngilizce karşılığını, yoksa orijinalini döndürüyoruz.
      return _translationMap[lowercased] ?? lowercased;
    }).join(','); // Sonuçları virgülle birleştiriyoruz.
  }

  @override
  Future<List<RecipeSuggestion>> getRandomRecipes() async {
    // ... Bu fonksiyonda değişiklik yok ...
    try {
      final response = await dio.get('/recipes/random', queryParameters: {'number': 10});
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['recipes'];
        return results.map((json) => RecipeSuggestion.fromJson(json)).toList();
      } else {
        throw 'API isteği başarısız oldu: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Beklenmedik bir hata oluştu: $e';
    }
  }

  @override
  Future<RecipeDetail> getRecipeDetailById(int id) async {
    // ... Bu fonksiyonda değişiklik yok ...
    try {
      final response = await dio.get('/recipes/$id/information');
      if (response.statusCode == 200) {
        return RecipeDetail.fromJson(response.data);
      } else {
        throw 'API isteği başarısız oldu: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Beklenmedik bir hata oluştu: $e';
    }
  }

  @override
  Future<List<RecipeSuggestion>> findRecipesByIngredients(List<String> ingredients) async {
    // DÜZENLENDİ: API'ye göndermeden önce malzemeleri çeviriyoruz.
    final ingredientsString = _translateIngredients(ingredients);

    try {
      final response = await dio.get(
        '/recipes/findByIngredients',
        queryParameters: {
          'ingredients': ingredientsString,
          'number': 20,
          'ranking': 1,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data;
        return results.map((json) => RecipeSuggestion.fromJson(json)).toList();
      } else {
        throw 'API isteği başarısız oldu: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Beklenmedik bir hata oluştu: $e';
    }
  }
}
