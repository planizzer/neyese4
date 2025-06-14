// lib/core/api/ai_service.dart

import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:neyese4/data/models/enriched_recipe_content.dart';
import 'package:neyese4/data/models/recipe_detail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService {
  // 1. Değişkenleri "static final" olarak değiştiriyoruz.
  // Bu, onların sadece bir kez oluşturulmasını ve sınıfa ait olmasını sağlar.
  static final String _apiKey = dotenv.env['GEMINI_API_KEY']!;

  static final _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey, // Artık _apiKey'e erişim güvenli.
    generationConfig: GenerationConfig(responseMimeType: 'application/json'),
  );

  // Geri kalan metodun kendisinde bir değişiklik yok.
  Future<EnrichedRecipeContent> getEnrichedRecipeContent(RecipeDetail recipe) async {
    final prompt =
        'You are a helpful and creative Turkish chef assistant. '
        'Take the following recipe and return a JSON object with four keys: "title_tr", "ingredients_tr", "instructions_tr", and "tips_tr".\n'
        '- "title_tr": Translate the recipe title to Turkish.\n'
        '- "ingredients_tr": Translate the list of ingredients to Turkish. Return it as a JSON array of strings.\n'
        '- "instructions_tr": Rewrite the recipe instructions in Turkish for a home cook. Format it as a single string with numbered steps (e.g., "1. Adım: ...\\n2. Adım: ...").\n'
        '- "tips_tr": Provide 2-3 useful and creative tips related to this recipe as a single string, with each tip starting with a "•" character and separated by a newline.\n\n'
        'Here is the recipe information:\n'
        'Title: ${recipe.title}\n'
        'Ingredients List: ${recipe.extendedIngredients.map((e) => e.original).toList()}\n'
        'Instructions: ${recipe.instructions}';

    try {
      // Modeli doğrudan kullanıyoruz.
      final response = await _model.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        final jsonMap = jsonDecode(response.text!) as Map<String, dynamic>;
        return EnrichedRecipeContent.fromJson(jsonMap);
      } else {
        throw 'Gemini boş yanıt döndürdü.';
      }
    } catch (e) {
      print('Gemini API hatası: $e');
      throw 'Tarif zenginleştirilemedi.';
    }
  }
}