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
        'Take the following recipe information and return a JSON object with the keys: "turkish_title", "difficulty", "readyInMinutes", "tags", "estimated_nutrition", "required_utensils", "ingredients_tr", "preparation_steps", and "chef_tips".\n'
        '- "turkish_title": (string) Translate the recipe title to Turkish.\n'
        '- "difficulty": (string) Estimate the difficulty as "Kolay", "Orta", or "Zor".\n'
        '- "readyInMinutes": (integer) Use the provided preparation time.\n'
        '- "tags": (array of strings) Provide 3-4 relevant Turkish tags (e.g., "akşam yemeği", "tavuklu", "fırında").\n'
        '- "estimated_nutrition": (object) Provide estimated values for "Kalori", "Protein", "Yağ", "Karbonhidrat".\n'
        '- "required_utensils": (array of strings) List the necessary kitchen utensils in Turkish.\n'
        '- "ingredients_tr": (array of objects) Translate the ingredients to Turkish. Each object must have "amount" (double), "unit" (string), and "name" (string).\n'
        '- "preparation_steps": (array of objects) Rewrite instructions in Turkish. Each object must have "step_number" (integer) and "description" (string).\n'
        '- "chef_tips": (array of strings) Provide 2-3 useful and creative tips in Turkish.\n\n'
        'Here is the recipe information to use:\n'
        'Title: ${recipe.title}\n'
        'Ready in Minutes: ${recipe.readyInMinutes}\n'
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