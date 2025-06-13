import 'package:hive/hive.dart';

// Bu dosyayı bir sonraki adımda build_runner ile üreteceğiz.
part 'kitchen_ingredient.g.dart';

// Her Hive nesnesi için benzersiz bir typeId belirliyoruz.
// SavedRecipe için 0 kullanmıştık, bunun için 1 kullanıyoruz.
@HiveType(typeId: 1)
class KitchenIngredient extends HiveObject {
  @HiveField(0)
  final String name;

  KitchenIngredient({
    required this.name,
  });
}
