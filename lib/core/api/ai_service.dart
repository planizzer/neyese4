// lib/core/api/ai_service.dart

import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:neyese4/data/models/enriched_recipe_content.dart';
import 'package:neyese4/data/models/recipe_detail.dart';
import 'package:neyese4/core/config/api_keys.dart'; // Yeni import
import 'dart:io'; // Dosya işlemleri için

class AiService {
  static const String _apiKey = ApiKeys.gemini; // Yeni kullanım şekli
  static final _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey, // Artık _apiKey'e erişim güvenli.
    generationConfig: GenerationConfig(responseMimeType: 'application/json'),
  );

// YENİ METOT: Ürün fotoğrafını ve diğer bilgileri analiz eder
  Future<Map<String, dynamic>> analyzeProductImage(File imageFile) async {
    final prompt =
        "Analyze the attached image of a food product. Your primary goal is to find a barcode. If a barcode is clearly visible, return a JSON object with only one key: 'barcode'. "
        "If no barcode is visible, then identify the following details: 'productName', 'brand', 'category', 'quantity', 'unit', and 'expirationDate'. "
        "For 'category', choose from this list: ['Sebze & Meyve', 'Et & Tavuk', 'Süt Ürünleri', 'Bakliyat', 'Baharatlar', 'İçecekler', 'Atıştırmalık', 'Diğer']. "
        "For 'quantity', find the numerical value (e.g., for '500 g', extract 500). "
        "For 'unit', find the unit of measurement and MAP IT to one of these exact values: ['adet', 'g', 'kg', 'ml', 'L', 'paket', 'dilim', 'kaşık']. For example, if you see 'gr' or 'grams', use 'g'. "
        "For 'expirationDate', look for 'TETT' or 'SKT' and return the date in 'YYYY-MM-DD' format. "
        "Return all found information in a single, clean JSON object. If you cannot identify a piece of information, omit its key. "
        "Example: {\"productName\": \"Sade Yulaf Ezmesi\", \"brand\": \"Eti Lifalif\", \"category\": \"Diğer\", \"quantity\": 500, \"unit\": \"g\", \"expirationDate\": \"2025-12-21\"}.";

    // Resmi byte dizisine çeviriyoruz
    final imageBytes = await imageFile.readAsBytes();

    // AI'a hem metin (prompt) hem de resmi (imageBytes) gönderiyoruz
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
      // Gelen cevabı doğru tipe çeviriyoruz
      return {
        'productName': jsonMap['productName'] as String? ?? '',
        'brand': jsonMap['brand'] as String? ?? '',
      };
    } else {
      throw Exception('Görüntü analizinden sonuç alınamadı.');
    }
  }
  // YENİ METOT: Bir liste dolusu başlığı tek seferde çevirir.
  Future<List<String>> translateRecipeTitles(List<String> titles) async {
    final prompt =
        'You are a helpful translator. Take the following JSON array of English recipe titles and return a JSON array of the same size with their Turkish translations. Maintain the original order and only return the JSON array.\n\n'
        'English Titles: ${jsonEncode(titles)}';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      if (response.text != null) {
        final List<dynamic> translatedList = jsonDecode(response.text!);
        return translatedList.map((e) => e.toString()).toList();
      } else {
        // Çeviri başarısız olursa orijinal başlıkları geri döndür
        return titles;
      }
    } catch (e) {
      print('Toplu başlık çevirme hatası: $e');
      return titles; // Hata durumunda orijinalleri döndür
    }
  }
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
        '- "preparation_steps": (array of objects) Rewrite instructions in Turkish. Each object must have "step_number" (integer), "description" (string), and optionally "duration_in_seconds" (integer) if the step requires a timer.\n'
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
        // YENİ EKLENDİ: AI'dan gelen ham cevabı konsola yazdır.
        print('--- GEMINI RAW RESPONSE ---');
        print(response.text!);
        print('---------------------------');

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