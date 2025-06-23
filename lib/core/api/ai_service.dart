// lib/core/api/ai_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:neyese4/core/config/api_keys.dart';
import 'package:neyese4/data/models/enriched_recipe_content.dart';
import 'package:neyese4/data/models/recipe_detail.dart';
import 'package:neyese4/data/models/user_preferences.dart';

class AiService {
  static const String _apiKey = ApiKeys.gemini;
  static final _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
    generationConfig: GenerationConfig(responseMimeType: 'application/json'),
  );

  // Ürün fotoğrafını analiz eden metot
  Future<Map<String, dynamic>> analyzeProductImage(File imageFile) async {
    const prompt =
        "Analyze the attached image of a food product. Your primary goal is to find a barcode. If a barcode is clearly visible, return a JSON object with only one key: 'barcode'. "
        "If no barcode is visible, then identify the following details: 'productName', 'brand', 'category', 'quantity', 'unit', and 'expirationDate'. "
        "For 'category', choose from this list: ['Sebze & Meyve', 'Et & Tavuk', 'Süt Ürünleri', 'Bakliyat', 'Baharatlar', 'İçecekler', 'Atıştırmalık', 'Diğer']. "
        "For 'quantity', find the numerical value of the weight/volume (e.g., for '500 g', extract 500). "
        "For 'unit', find the unit of measurement and MAP IT to one of these exact values: ['adet', 'g', 'kg', 'ml', 'L', 'paket', 'dilim', 'kaşık']. For example, if you see 'gr' or 'grams', use 'g'. "
        "For 'expirationDate', look for 'TETT' or 'SKT' and return the date in 'YYYY-MM-DD' format. "
        "Return all found information in a single, clean JSON object. If you cannot identify a piece of information, omit its key. "
        "Example for a full analysis: {\"productName\": \"Sade Yulaf Ezmesi\", \"brand\": \"Eti Lifalif\", \"category\": \"Diğer\", \"quantity\": 500, \"unit\": \"g\", \"expirationDate\": \"2025-12-21\"}.";

    final imageBytes = await imageFile.readAsBytes();
    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', imageBytes),
      ])
    ];

    final response = await _model.generateContent(content);

    if (response.text != null) {
      print('--- VISION AI RESPONSE ---');
      print(response.text!);
      print('--------------------------');
      final jsonMap = jsonDecode(response.text!) as Map<String, dynamic>;
      return jsonMap;
    } else {
      throw Exception('Görüntü analizinden sonuç alınamadı.');
    }
  }

  // Tarif başlıklarını toplu halde çeviren metot
  Future<List<String>> translateRecipeTitles(List<String> titles) async {
    final prompt =
        'You are a helpful translator. Take the following JSON array of English recipe titles and return a JSON array of the same size with their Turkish translations. Maintain the original order and only return the JSON array.\n\n'
        'English Titles: ${jsonEncode(titles)}';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      if (response.text != null) {
        final List<dynamic> translatedList = jsonDecode(response.text!);
        return translatedList.map((e) => e.toString()).toList();
      }
      return titles;
    } catch (e) {
      print('Toplu başlık çevirme hatası: $e');
      return titles;
    }
  }

  Future<List<String>> translateIngredientsToEnglish(List<String> turkishIngredients) async {
    final prompt =
        'You are a helpful translator. Take the following JSON array of Turkish food ingredient names and return a JSON array of the same size with their single-word or common compound English translations. Maintain the original order and only return the JSON array.\n\n'
        'Turkish Ingredients: ${jsonEncode(turkishIngredients)}';
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      if (response.text != null) {
        final List<dynamic> translatedList = jsonDecode(response.text!);
        return translatedList.map((e) => e.toString()).toList();
      }
      return turkishIngredients;
    } catch (e) {
      print('Malzeme çevirme hatası: $e');
      return turkishIngredients;
    }
  }

  // "Usta Şef" Master Prompt'unu içeren ana metot
  Future<EnrichedRecipeContent> getEnrichedRecipeContent({
    required RecipeDetail recipe,
    required int targetServings,
    required UserPreferences userPreferences,
    required List<String> pantryIngredients,
  }) async {
    final prompt = '''
You are a world-class Turkish chef and a helpful nutritional assistant. Your task is to take a raw recipe, PERSONALISE it for a specific user, SCALE it for a new portion size, and enrich it.

**CONTEXT (Who you are helping):**
The user you are helping has the following profile:
- Target Servings: $targetServings people (the original recipe is for ${recipe.servings} people).
- Diet: ${userPreferences.diet ?? 'None'}.
- Allergies: ${userPreferences.intolerances?.join(', ') ?? 'None'}.
- Ingredients they have at home (Pantry): ${pantryIngredients.join(', ')}.

**YOUR TASK (What to do):**
Based on the user's context and the raw recipe data below, you must return a single, valid JSON object.

**OUTPUT FORMAT (How to respond):**
The JSON object must have these exact keys:
- "turkish_title": (string) The Turkish title of the recipe.
- "difficulty": (string) "Çok Kolay", "Kolay", "Orta", or "Zor".
- "readyInMinutes": (integer) The original preparation time.
- "tags": (array of strings) 3-4 relevant Turkish tags.
- "estimated_nutrition": (object) Estimated nutrition values for the SCALED portion size.
- "required_utensils": (array of strings) Necessary kitchen utensils.
- "ingredients_tr": (array of objects) **Crucially, scale the ingredient amounts for the 'targetServings'**. The original recipe is for ${recipe.servings} servings. If the original calls for "200g flour" for 2 servings, and the target is 4 servings, you must return "400g flour". Each object must have "amount" (double), "unit" (string), "name" (string).
- "preparation_steps": (array of objects) Rewrite the instructions in a "chef-like" style. Be descriptive, encouraging, and clear. Use bullet points (\\n- ) for clarity. Each object must contain:
  - "step_number": (integer)
  - "description": (string) The detailed, chef-like instruction.
  - "step_ingredients": (array of strings) A list of ingredients used ONLY in this specific step. **This is a mandatory field.**
  - "duration_in_seconds": (integer, optional) The estimated duration of the step in seconds, if applicable.
- "chef_tips": (array of strings) 2-3 genuinely useful "chef secrets".
- "allergen_warnings": (array of strings) **Check if the recipe contains any of the user's allergies.** If it does, add a warning string for each allergen found. Example: "Uyarı: Bu tarif, 'Süt Ürünleri' alerjinizle uyumsuz olabilir." If none, return an empty array [].
- "dietary_warnings": (array of strings) **Check if the recipe conflicts with the user's diet.** Example: If user's diet is 'Vegan' and recipe contains 'chicken', add "Uyarı: Bu tarif, 'Vegan' diyetinizle uyumlu değildir.". If none, return an empty array [].
- "substitution_suggestions": (array of strings) **Check if any recipe ingredient is NOT in the user's pantry.** For each missing ingredient, suggest a common substitute. Example: "Kilerinizde olmayan 'balsamik sirke' yerine elma sirkesi kullanabilirsiniz.". If all ingredients are present, return an empty array [].


**RAW RECIPE DATA TO BE TRANSFORMED:**
Title: ${recipe.title}
Original Servings: ${recipe.servings}
Ingredients List: ${recipe.extendedIngredients.map((e) => e.original).toList()}
Instructions: ${recipe.instructions}
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      if (response.text != null) {
        print('--- MASTER PROMPT RESPONSE ---');
        print(response.text!);
        print('------------------------------');
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