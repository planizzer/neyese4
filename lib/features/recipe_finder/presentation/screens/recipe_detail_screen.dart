import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/recipe_detail.dart';
import 'package:neyese4/data/models/saved_recipe.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/recipe_finder/application/recipe_providers.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final int recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  String _stripHtmlIfNeeded(String text) {
    // Bu fonksiyonu daha sonra Gemini'den gelen metin formatlı olacağı için kaldırabiliriz
    // veya gelen metni güvenli hale getirmek için tutabiliriz.
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Önce ham tarif detayını API'den çekiyoruz.
    final recipeDetailAsyncValue = ref.watch(recipeDetailProvider(recipeId));

    return Scaffold(
      backgroundColor: AppColors.background,
      // 2. Ham tarifin durumuna göre arayüzü çiziyoruz.
      body: recipeDetailAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Tarif yüklenemedi: $err')),
        // 3. Ham tarif verisi başarıyla geldiğinde:
        data: (recipe) {
          // 4. Şimdi de bu ham tarifi kullanarak Gemini'den zenginleştirilmiş metni istiyoruz.
          final enrichedContentAsyncValue = ref.watch(enrichedInstructionsProvider(recipe));
          final isSaved = ref.watch(isRecipeSavedProvider(recipeId));
          final imageUrl = kIsWeb ? 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(recipe.image)}' : recipe.image;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                title: Text(recipe.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                centerTitle: false,
                actions: [
                  IconButton(
                    icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border_outlined, color: isSaved ? AppColors.primaryAction : null),
                    onPressed: () async {
                      final savedRecipeRepository = ref.read(savedRecipeRepositoryProvider);
                      if (isSaved) {
                        await savedRecipeRepository.deleteRecipe(recipeId);
                      } else {
                        await savedRecipeRepository.saveRecipe(SavedRecipe(id: recipe.id, title: recipe.title, image: recipe.image));
                      }
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.error)),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoChip(Icons.timer_outlined, '${recipe.readyInMinutes} dk'),
                          _buildInfoChip(Icons.food_bank_outlined, '${recipe.extendedIngredients.length} malzeme'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(recipe.title, style: AppTextStyles.h1),
                      const SizedBox(height: 24),
                      const Text('Malzemeler', style: AppTextStyles.h2),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recipe.extendedIngredients.length,
                          itemBuilder: (context, index) => Text('• ${recipe.extendedIngredients[index].original}', style: AppTextStyles.body),
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text('Hazırlanışı', style: AppTextStyles.h2),
                      const SizedBox(height: 8),
                      // 5. Zenginleştirilmiş içeriğin durumuna göre arayüzü çiziyoruz.
                      enrichedContentAsyncValue.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Text('Tarif zenginleştirilemedi: $err', style: AppTextStyles.body.copyWith(color: Colors.red)),
                        data: (enrichedText) => Text(
                          enrichedText, // Gemini'den gelen zengin metin burada gösteriliyor.
                          style: AppTextStyles.body.copyWith(height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          label: const Text('Tarifi Yapmaya Başla', style: AppTextStyles.button),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) => Chip(
    avatar: Icon(icon, color: AppColors.primaryAction, size: 20),
    label: Text(label, style: AppTextStyles.body),
    backgroundColor: AppColors.primaryAction.withAlpha(25),
    side: BorderSide.none,
  );
}
