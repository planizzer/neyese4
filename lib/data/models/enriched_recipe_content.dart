// Bu basit sınıf, Gemini'den gelen yapılandırılmış veriyi tutar.
class EnrichedRecipeContent {
  final String title;
  final List<String> ingredients;
  final String instructions;
  final String tips; // YENİ EKLENDİ: Püf noktaları için ayrı bir alan

  EnrichedRecipeContent({
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.tips,
  });

  // Gelen JSON'ı bu nesneye çevirmek için bir fabrika metodu.
  factory EnrichedRecipeContent.fromJson(Map<String, dynamic> json) {
    final ingredientsList = (json['ingredients_tr'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ?? [];

    return EnrichedRecipeContent(
      title: json['title_tr'] as String? ?? 'Başlık Çevrilemedi',
      ingredients: ingredientsList,
      instructions: json['instructions_tr'] as String? ?? 'Talimatlar zenginleştirilemedi.',
      tips: json['tips_tr'] as String? ?? '', // Püf noktalarını alıyoruz.
    );
  }
}
