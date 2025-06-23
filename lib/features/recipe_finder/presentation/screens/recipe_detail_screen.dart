// lib/features/recipe_finder/presentation/screens/recipe_detail_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/saved_recipe.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/recipe_finder/presentation/screens/cooking_mode_screen.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/chef_tips_card.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/ingredients_card.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/nutrition_card.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/preparation_steps_card.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/recipe_title_and_meta_card.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/utensils_card.dart';
import 'package:neyese4/core/widgets/chef_loading_indicator.dart';


class RecipeDetailScreen extends ConsumerWidget {
  final int recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsyncValue = ref.watch(fullRecipeProvider(recipeId));

    return recipeAsyncValue.when(
      loading: () => Scaffold(body: Center(child: ChefLoadingIndicator())),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Hata')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Tarif yüklenemedi.\nLütfen internet bağlantınızı kontrol edin.\nHata: $err',
                textAlign: TextAlign.center),
          ),
        ),
      ),
      data: (content) {
        final isSaved = ref.watch(isRecipeSavedProvider(recipeId));
        const double cardSpacing = 24.0;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    content.title,
                    style: const TextStyle(
                        fontSize: 16,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 1))]),
                  ),
                  background: Image.network(
                    kIsWeb
                        ? 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(content.imageUrl)}'
                        : content.imageUrl,
                    fit: BoxFit.cover,
                    // YENİ EKLENEN BÖLÜM:
                    errorBuilder: (context, error, stackTrace) {
                      // Hata durumunda gösterilecek yedek widget
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                          size: 64,
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  // isRecipeSavedProvider'ın sonucunu anlık dinlemek için bir Consumer kullanıyoruz.
                  Consumer(
                    builder: (context, ref, child) {
                      // Artık bir Future olduğu için sonucunu "isSavedAsync" olarak alıyoruz.
                      final isSavedAsync = ref.watch(isRecipeSavedProvider(recipeId));

                      // Future'ın durumuna göre (yükleniyor, hata, veri) farklı widget'lar gösteriyoruz.
                      return isSavedAsync.when(
                        // Veri yüklenirken küçük bir dönme animasyonu göster
                        loading: () => const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                        ),
                        // Hata durumunda bir hata ikonu göster
                        error: (err, stack) => const IconButton(icon: Icon(Icons.error_outline, color: Colors.red), onPressed: null),
                        // Veri geldiğinde duruma göre doğru ikonu göster
                        data: (isSaved) => IconButton(
                          icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border_outlined, color: isSaved ? AppColors.primaryAction : null),
                          onPressed: () async { // <-- async ekle
                            final repository = ref.read(firestoreRepositoryProvider);
                            if (isSaved) {
                              await repository.deleteRecipe(recipeId); // await ekle
                            } else {
                              await repository.saveRecipe( // await ekle
                                SavedRecipe(id: recipeId, title: content.title, image: content.imageUrl),
                              );
                            }
                            // İŞTE SİHİRLİ SATIR: Provider'ı tetikleyerek arayüzü güncellemeye zorla.
                            ref.invalidate(isRecipeSavedProvider(recipeId));
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      RecipeTitleAndMetaCard(content: content),
                      const SizedBox(height: cardSpacing),
                      IngredientsCard(content: content),
                      const SizedBox(height: cardSpacing),
                      UtensilsCard(content: content),
                      const SizedBox(height: cardSpacing),
                      PreparationStepsCard(content: content),
                      const SizedBox(height: cardSpacing),
                      ChefTipsCard(content: content),
                      const SizedBox(height: cardSpacing),
                      NutritionCard(content: content),
                      const SizedBox(height: cardSpacing + 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
              onPressed: () {
                if (content.preparationSteps.isNotEmpty) { // Bu kontrolü eklemek iyi bir pratik
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CookingModeScreen(
                        recipeTitle: content.title,
                        steps: content.preparationSteps,
                        mainImageUrl: content.imageUrl, // <-- EKLENECEK TEK SATIR BU
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bu tarif için hazırlık adımları bulunamadı.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              label: const Text('Tarifi Yapmaya Başla', style: AppTextStyles.button),
            ),
          ),
        );
      },
    );
  }
}