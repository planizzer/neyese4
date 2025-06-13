import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/saved_recipe.dart'; // SavedRecipe modelini import ediyoruz.
import 'package:neyese4/data/providers.dart'; // Ana provider'ları import ediyoruz.
import 'package:neyese4/features/recipe_finder/application/recipe_providers.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeDetailAsyncValue = ref.watch(recipeDetailProvider(recipeId));
    final isSaved = ref.watch(isRecipeSavedProvider(recipeId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: recipeDetailAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Tarif yüklenemedi: $err')),
        data: (recipe) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                title: Text(recipe.title),
                centerTitle: false,
                actions: [
                  IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border_outlined,
                      color: isSaved ? AppColors.primaryAction : null,
                    ),
                    onPressed: () {
                      // DÜZENLENDİ: Butona basıldığında artık veritabanına yazıyoruz.
                      final savedRecipeRepository = ref.read(savedRecipeRepositoryProvider);
                      if (isSaved) {
                        // Eğer zaten kayıtlıysa, veritabanından siliyoruz.
                        savedRecipeRepository.deleteRecipe(recipeId);
                      } else {
                        // Kayıtlı değilse, yeni bir SavedRecipe nesnesi oluşturup
                        // veritabanına kaydediyoruz.
                        final recipeToSave = SavedRecipe(
                          id: recipe.id,
                          title: recipe.title,
                          image: recipe.image,
                        );
                        savedRecipeRepository.saveRecipe(recipeToSave);
                      }
                      // UI'ın anında güncellenmesi için ilgili provider'ları "geçersiz kıl" diyoruz.
                      ref.invalidate(isRecipeSavedProvider(recipeId));
                      ref.invalidate(savedRecipesListProvider);
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(recipe.image, fit: BoxFit.cover),
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
                          itemBuilder: (context, index) {
                            final ingredient = recipe.extendedIngredients[index];
                            return Text('• ${ingredient.original}', style: AppTextStyles.body);
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('Hazırlanışı', style: AppTextStyles.h2),
                      const SizedBox(height: 8),
                      Text(_stripHtmlIfNeeded(recipe.instructions), style: AppTextStyles.body.copyWith(height: 1.5)),
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

  Widget _buildInfoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, color: AppColors.primaryAction, size: 20),
      label: Text(label, style: AppTextStyles.body),
      backgroundColor: AppColors.primaryAction.withOpacity(0.1),
      side: BorderSide.none,
    );
  }
}
