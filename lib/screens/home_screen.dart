import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/features/recipe_finder/application/recipe_providers.dart';
// Yeni oluşturduğumuz detay sayfasını import ediyoruz.
import 'package:neyese4/features/recipe_finder/presentation/screens/recipe_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final randomRecipesAsyncValue = ref.watch(randomRecipesProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- MALZEME GİRİŞ BÖLÜMÜ (Değişiklik yok) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mutfağında ne var?', style: AppTextStyles.h1),
                  const SizedBox(height: 8),
                  const Text('Malzemelerini gir, sana ne yapabileceğini söyleyelim.', style: AppTextStyles.body),
                  const SizedBox(height: 32),
                  _buildIngredientTextField(hintText: '1. Malzeme (örn: Tavuk)'),
                  const SizedBox(height: 16),
                  _buildIngredientTextField(hintText: '2. Malzeme (örn: Domates)'),
                  const SizedBox(height: 16),
                  _buildIngredientTextField(hintText: '3. Malzeme (isteğe bağlı)'),
                  const SizedBox(height: 16),
                  _buildIngredientTextField(hintText: '4. Malzeme (isteğe bağlı)'),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
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

            // --- GÜNÜN ÖNERİLERİ BÖLÜMÜ ---
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
                      // Kartı oluştururken artık 'context'i de gönderiyoruz.
                      // Bu, Navigator'ın hangi ekrandan geldiğini bilmesi için gereklidir.
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

  Widget _buildIngredientTextField({required String hintText}) {
    return TextField(
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

  // Öneri kartı widget'ı GÜNCELLENDİ (GestureDetector eklendi)
  Widget _buildSuggestionCard({required BuildContext context, required RecipeSuggestion recipe}) {
    // Karta tıklama özelliği eklemek için GestureDetector kullanıyoruz.
    // Bu widget, altındaki widget'a dokunma, sürükleme gibi hareketleri algılar.
    return GestureDetector(
      onTap: () {
        // Tıklandığında yapılacak eylem:
        print('Tıklandı: ${recipe.title} (ID: ${recipe.id})'); // Hata ayıklama için konsola yazdır.

        // Navigator.push ile yeni bir sayfaya geçiş yapıyoruz.
        // Bu, Flutter'ın standart sayfa geçiş yöntemidir.
        Navigator.of(context).push(
          MaterialPageRoute(
            // Gidilecek sayfayı ve o sayfaya göndereceğimiz veriyi (recipeId) belirtiyoruz.
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
                  loadingBuilder: (context, child, progress) {
                    return progress == null ? child : const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(height: 120, width: 150, color: Colors.grey[200], child: const Icon(Icons.broken_image, color: Colors.grey));
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                recipe.title,
                style: AppTextStyles.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
