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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeDetailAsyncValue = ref.watch(recipeDetailProvider(recipeId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: recipeDetailAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Tarif yüklenemedi: $err')),
        data: (recipe) {
          final enrichedContentAsyncValue = ref.watch(enrichedRecipeProvider(recipe));
          final isSaved = ref.watch(isRecipeSavedProvider(recipeId));
          final imageUrl = kIsWeb ? 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(recipe.image)}' : recipe.image;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                title: enrichedContentAsyncValue.when(
                  data: (content) => Text(content.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  loading: () => Text(recipe.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  error: (_, __) => Text(recipe.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
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
              // SliverToBoxAdapter, Sliver'lar içinde normal widget'lar kullanmamızı sağlar.
              SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    // Gemini'den gelen zenginleştirilmiş içeriği bekliyoruz.
                    child: enrichedContentAsyncValue.when(
                      loading: () => const Center(heightFactor: 5, child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Tarif içeriği yüklenemedi: $err', style: const TextStyle(color: Colors.red))),
                      data: (content) {
                        // YENİ VE ŞIK ARAYÜZ
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Başlık ve Özet Bilgiler
                            Text(content.title, style: AppTextStyles.h1),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _buildInfoChip(Icons.timer_outlined, '${recipe.readyInMinutes} dk'),
                                const SizedBox(width: 8),
                                _buildInfoChip(Icons.food_bank_outlined, '${content.ingredients.length} malzeme'),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Malzemeler Bölümü
                            const Text('Malzemeler', style: AppTextStyles.h2),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade200)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: content.ingredients
                                    .map((ingredient) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text('• $ingredient', style: AppTextStyles.body),
                                ))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Hazırlanışı Bölümü
                            const Text('Hazırlanışı', style: AppTextStyles.h2),
                            const SizedBox(height: 12),
                            Text(
                              content.instructions,
                              style: AppTextStyles.body.copyWith(height: 1.6, fontSize: 17),
                            ),

                            // Püf Noktaları Bölümü (Eğer varsa)
                            if (content.tips.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              const Text('Püf Noktaları', style: AppTextStyles.h2),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryAction.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                    content.tips,
                                    style: AppTextStyles.body.copyWith(height: 1.5, fontStyle: FontStyle.italic)
                                ),
                              )
                            ],

                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                                onPressed: () {
                                  // TODO: İnteraktif Pişirme Modu sayfası açılacak.
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                label: const Text('Tarifi Yapmaya Başla', style: AppTextStyles.button),
                              ),
                            ),
                          ],
                        );
                      },
                    )
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
    backgroundColor: AppColors.primaryAction.withOpacity(0.1),
    side: BorderSide.none,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  );
}
