import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/features/profile/application/profile_providers.dart';
import 'package:neyese4/features/recipe_finder/application/recipe_providers.dart';
import 'package:neyese4/features/recipe_finder/application/search_query.dart';
import 'package:neyese4/features/recipe_finder/presentation/screens/recipe_detail_screen.dart';
import 'package:neyese4/features/recipe_finder/presentation/screens/recipe_results_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _ingredient1Controller = TextEditingController();
  final _ingredient2Controller = TextEditingController();
  final _ingredient3Controller = TextEditingController();
  final _ingredient4Controller = TextEditingController();

  @override
  void dispose() {
    _ingredient1Controller.dispose();
    _ingredient2Controller.dispose();
    _ingredient3Controller.dispose();
    _ingredient4Controller.dispose();
    super.dispose();
  }

  void _findRecipes() {
    final ingredients = [
      _ingredient1Controller.text,
      _ingredient2Controller.text,
      _ingredient3Controller.text,
      _ingredient4Controller.text,
    ]
        .where((text) => text.trim().isNotEmpty)
        .map((text) => text.trim())
        .toList();

    if (ingredients.isNotEmpty) {
      // Kullanıcının kayıtlı tercihlerini okuyoruz.
      final userPrefs = ref.read(userPreferencesProvider);

      // Arama nesnesini oluştururken artık 'equipment' bilgisini de ekliyoruz.
      final searchQuery = SearchQuery(
        ingredients: ingredients,
        diet: userPrefs.diet,
        intolerances: userPrefs.intolerances,
        equipment: userPrefs.equipment, // DÜZELTME: Bu satır eklendi.
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RecipeResultsScreen(searchQuery: searchQuery),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir malzeme girin.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final randomRecipesAsyncValue = ref.watch(randomRecipesProvider);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mutfağında ne var?', style: AppTextStyles.h1),
                  const SizedBox(height: 8),
                  const Text(
                    'Malzemelerini gir, sana ne yapabileceğini söyleyelim.',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 32),
                  _buildIngredientTextField(controller: _ingredient1Controller, hintText: '1. Malzeme (örn: Tavuk)'),
                  const SizedBox(height: 16),
                  _buildIngredientTextField(controller: _ingredient2Controller, hintText: '2. Malzeme (örn: Domates)'),
                  const SizedBox(height: 16),
                  _buildIngredientTextField(controller: _ingredient3Controller, hintText: '3. Malzeme (isteğe bağlı)'),
                  const SizedBox(height: 16),
                  _buildIngredientTextField(controller: _ingredient4Controller, hintText: '4. Malzeme (isteğe bağlı)'),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _findRecipes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryAction,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Tarif Bul', style: AppTextStyles.button),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('Günün Önerileri', style: AppTextStyles.h2),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: randomRecipesAsyncValue.when(
                data: (recipes) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recipes.length,
                  padding: const EdgeInsets.only(left: 24.0, right: 8.0),
                  itemBuilder: (context, index) => _buildSuggestionCard(context: context, recipe: recipes[index]),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => const Center(child: Text('Öneriler yüklenemedi.')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientTextField({required TextEditingController controller, required String hintText}) {
    return TextField(
      controller: controller,
      style: AppTextStyles.input,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.caption.copyWith(fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.neutralGrey, width: 0.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.neutralGrey.withOpacity(0.5), width: 1.0)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryAction, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }

  Widget _buildSuggestionCard({required BuildContext context, required RecipeSuggestion recipe}) {
    // DÜZELTME: Güvenilir proxy ve doğru URL kodlaması kullanılıyor.
    final imageUrl = kIsWeb ? 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(recipe.image)}' : recipe.image;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipeId: recipe.id))),
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  imageUrl, // Düzeltilmiş URL'yi kullanıyoruz.
                  height: 120,
                  width: 150,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, error, stackTrace) => Container(height: 120, width: 150, color: Colors.grey[200], child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 8),
              Text(recipe.title, style: AppTextStyles.body, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
