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
    double parsedAmount = 0.0;
    final dynamic amountValue = json['amount']; // Değeri önce 'dynamic' olarak alıyoruz.

    if (amountValue is num) {
      // Eğer gelen değer zaten bir sayı ise, doğrudan kullan.
      parsedAmount = amountValue.toDouble();
    } else if (amountValue is String) {
      // Eğer gelen değer bir metin ise, sayıya çevirmeyi dene.
      // Başarısız olursa (örn: "biraz" gibi bir metin gelirse), varsayılan olarak 0.0 kullan.
      parsedAmount = double.tryParse(amountValue) ?? 0.0;
    }

    return IngredientInfo(
      amount: parsedAmount,
      unit: json['unit'] as String? ?? '',
      name: json['name'] as String? ?? 'Bilinmeyen Malzeme',
    );
  }
}