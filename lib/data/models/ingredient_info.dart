// lib/data/models/ingredient_info.dart

class IngredientInfo {
  final double amount;
  final String unit;
  final String name;

  IngredientInfo({
    required this.amount,
    required this.unit,
    required this.name,
  });

  // YENİ EKLENDİ: fromJson metodu
  factory IngredientInfo.fromJson(Map<String, dynamic> json) {
    return IngredientInfo(
      // num olarak gelen veriyi double'a çeviriyoruz.
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String? ?? '',
      name: json['name'] as String? ?? 'Bilinmeyen Malzeme',
    );
  }
}