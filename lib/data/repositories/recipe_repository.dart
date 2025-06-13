import 'package:dio/dio.dart';
import 'package:neyese4/data/models/recipe_detail.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';

// Sözleşmemize yeni bir metod ekliyoruz.
abstract class RecipeRepository {
  Future<List<RecipeSuggestion>> getRandomRecipes();
  Future<RecipeDetail> getRecipeDetailById(int id); // YENİ EKLENDİ
}

class SpoonacularRecipeRepository implements RecipeRepository {
  final Dio dio;
  SpoonacularRecipeRepository({required this.dio});

  @override
  Future<List<RecipeSuggestion>> getRandomRecipes() async {
    try {
      final response = await dio.get('/recipes/random', queryParameters: {'number': 10});
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['recipes'];
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

  // YENİ METODUN İÇİNİ DOLDURUYORUZ
  @override
  Future<RecipeDetail> getRecipeDetailById(int id) async {
    try {
      // API'de bir tarifin detayını almak için /recipes/{id}/information adresine gidiyoruz.
      final response = await dio.get('/recipes/$id/information');
      if (response.statusCode == 200) {
        // Gelen JSON direkt olarak tarif detayını içerdiği için
        // doğrudan modelimize dönüştürüyoruz.
        return RecipeDetail.fromJson(response.data);
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
