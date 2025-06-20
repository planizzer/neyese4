import 'package:hive/hive.dart';

// Bu dosyayı bir sonraki adımda build_runner ile üreteceğiz.
part 'saved_recipe.g.dart';

// Hive'ın bu nesneyi tanıyabilmesi için @HiveType notasyonunu ekliyoruz.
// typeId her Hive nesnesi için benzersiz olmalıdır.
@HiveType(typeId: 0)
class SavedRecipe extends HiveObject {
  // Saklayacağımız her alan için @HiveField ekliyoruz.
  // index'ler benzersiz ve sıralı olmalı.
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String image;

  SavedRecipe({
    required this.id,
    required this.title,
    required this.image,
  });
}
