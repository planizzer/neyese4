import 'package:hive/hive.dart';

part 'pantry_item.g.dart';

@HiveType(typeId: 1) // Eski typeId'yi yeniden kullanabiliriz.
class PantryItem extends HiveObject {

  @HiveField(0)
  final String productName;

  @HiveField(1)
  final String? brand;

  @HiveField(2)
  final double quantity;

  @HiveField(3)
  final String unit; // "g", "adet", "ml"

  @HiveField(4)
  final String category; // "Sebze & Meyve", "Süt Ürünleri" vb.

  @HiveField(5)
  final DateTime addedDate;

  @HiveField(6)
  final DateTime? expirationDate;

  @HiveField(7) // YENİ ALAN
  final String? barcode;

  PantryItem({
    required this.productName,
    this.brand,
    required this.quantity,
    required this.unit,
    required this.category,
    required this.addedDate,
    this.expirationDate,
    this.barcode,
  });
}