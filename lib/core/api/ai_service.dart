import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:neyese4/data/models/recipe_detail.dart';

class AiService {
  // 2. Adımda aldığın Gemini API Anahtarını buraya yapıştır.
  static const String _apiKey = 'AIzaSyDAZ4USY3WwtY-TUgBg5XQ1TcKw4XRD0EU';

  // Gemini modelini başlatıyoruz.
  final _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);

  // Bu fonksiyon, bir tarifi alıp onu zenginleştirmek için AI'a gönderir.
  Future<String> getEnrichedInstructions(RecipeDetail recipe) async {
    // AI'a ne yapmasını istediğimizi anlatan bir "istek metni" (prompt) oluşturuyoruz.
    final prompt =
        'You are a helpful and creative Turkish chef assistant. '
        'Take the following recipe and rewrite it for a home cook in Turkish. '
        'The output should be clear, friendly, and encouraging. '
        'Format the instructions as a numbered list. '
        'After the instructions, add a "Püf Noktaları" section with 2-3 useful tips related to this recipe. '
        'Here is the recipe information:\n'
        'Title: ${recipe.title}\n'
        'Ingredients: ${recipe.extendedIngredients.map((e) => e.original).join(', ')}\n'
        'Instructions: ${recipe.instructions}';

    try {
      // Oluşturduğumuz prompt'u Gemini'ye gönderiyoruz.
      final response = await _model.generateContent([Content.text(prompt)]);
      // Gelen cevabın metnini geri döndürüyoruz.
      return response.text ?? 'Tarif zenginleştirilemedi.';
    } catch (e) {
      print('Gemini API hatası: $e');
      return 'Tarif zenginleştirilemedi.';
    }
  }
}

