import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 2)
class UserPreferences extends HiveObject {
  @HiveField(0)
  String? diet;

  @HiveField(1)
  List<String>? intolerances;

  // YENİ EKLENDİ: Mutfak aletlerini saklamak için yeni bir alan.
  @HiveField(2)
  List<String>? equipment;

  UserPreferences({
    this.diet,
    this.intolerances,
    this.equipment, // Yeni alanı constructor'a ekliyoruz.
  });
}
