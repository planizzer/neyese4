// lib/core/config/api_keys.dart

class ApiKeys {
  // SPOONACULAR_API_KEY adıyla derleme anında verilen değeri oku.
  static const spoonacular = String.fromEnvironment('SPOONACULAR_API_KEY');

  // GEMINI_API_KEY adıyla derleme anında verilen değeri oku.
  static const gemini = String.fromEnvironment('GEMINI_API_KEY');
}