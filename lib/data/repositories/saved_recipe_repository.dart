import 'package:hive_flutter/hive_flutter.dart';
import 'package:neyese4/data/models/saved_recipe.dart';

// Veritabanı kutusunun adını bir sabite atıyoruz.
const String kSavedRecipesBox = 'saved_recipes_box';

class SavedRecipeRepository {
  // Hive kutusuna erişmek için bir getter.
  // Bu, Hive'ın verileri sakladığı dijital bir kutu/dosyadır.
  Box<SavedRecipe> get _box => Hive.box<SavedRecipe>(kSavedRecipesBox);

  // Verilen ID'ye sahip bir tarifi kutuya ekler.
  // 'put' metodu, ID'yi anahtar olarak kullanarak veriyi saklar.
  Future<void> saveRecipe(SavedRecipe recipe) async {
    await _box.put(recipe.id, recipe);
  }

  // Verilen ID'ye sahip bir tarifi kutudan siler.
  Future<void> deleteRecipe(int recipeId) async {
    await _box.delete(recipeId);
  }

  // Bir tarifin kutuda olup olmadığını kontrol eder.
  bool isRecipeSaved(int recipeId) {
    return _box.containsKey(recipeId);
  }

  // Kutudaki tüm tariflerin bir listesini döndürür.
  List<SavedRecipe> getAllSavedRecipes() {
    return _box.values.toList();
  }

  // Kutudaki değişiklikleri dinlemek için bir Stream sağlar.
  // Bu, "Tariflerim" sayfasının anında güncellenmesini sağlayacak.
  Stream<BoxEvent> watchRecipes() {
    return _box.watch();
  }
}
