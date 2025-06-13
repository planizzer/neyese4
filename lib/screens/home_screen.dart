import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/features/recipe_finder/application/recipe_providers.dart';
import 'package:neyese4/features/recipe_finder/presentation/screens/recipe_detail_screen.dart';
import 'package:neyese4/features/recipe_finder/presentation/screens/recipe_results_screen.dart'; // Yeni sayfamızı import ediyoruz

// Metin kutularının durumunu yönetmek için StatefulWidget'a geçiyoruz.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Her metin kutusu için bir TextEditingController oluşturuyoruz.
  // Bu, kutuların içindeki metni okumamızı sağlar.
  final _ingredient1Controller = TextEditingController();
  final _ingredient2Controller = TextEditingController();
  final _ingredient3Controller = TextEditingController();
  final _ingredient4Controller = TextEditingController();

  // Widget ağacından kaldırıldığında controller'ları temizliyoruz.
  // Bu, hafıza sızıntılarını önler.
  @override
  void dispose() {
    _ingredient1Controller.dispose();
    _ingredient2Controller.dispose();
    _ingredient3Controller.dispose();
    _ingredient4Controller.dispose();
    super.dispose();
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
                  const Text('Malzemelerini gir, sana ne yapabileceğini söyleyelim.', style: AppTextStyles.body),
                  const SizedBox(height: 32),
                  // Metin kutularını controller'lar ile bağlıyoruz.
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
                      // BUTONA TIKLAMA MANTIĞI EKLENDİ
                      onPressed: () {
                        // Controller'lardaki metinleri bir listeye topluyoruz.
                        final ingredients = [
                          _ingredient1Controller.text,
                          _ingredient2Controller.text,
                          _ingredient3Controller.text,
                          _ingredient4Controller.text,
                        ]
                        // Sadece dolu olanları alıyoruz ve baş/sondaki boşlukları siliyoruz.
                            .where((text) => text.trim().isNotEmpty)
                            .map((text) => text.trim())
                            .toList();

                        // Eğer en az bir malzeme girildiyse, sonuçlar sayfasına yönlendir.
                        if (ingredients.isNotEmpty) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RecipeResultsScreen(ingredients: ingredients),
                            ),
                          );
                        } else {
                          // Eğer hiç malzeme girilmediyse kullanıcıya bir uyarı göster.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Lütfen en az bir malzeme girin.')),
                          );
                        }
                      },
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
                data: (recipes) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recipes.length,
                    padding: const EdgeInsets.only(left: 24.0, right: 8.0),
                    itemBuilder: (context, index) {
                      return _buildSuggestionCard(context: context, recipe: recipes[index]);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Hata: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget artık bir controller alıyor.
  Widget _buildIngredientTextField({required TextEditingController controller, required String hintText}) {
    return TextField(
      controller: controller, // Controller'ı TextField'a atıyoruz.
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipeId: recipe.id),
          ),
        );
      },
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
                  recipe.image,
                  height: 120,
                  width: 150,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, error, stackTrace) => Container(height: 120, width: 150, color: Colors.grey[200], child: const Icon(Icons.broken_image, color: Colors.grey)),
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
