// lib/features/recipe_finder/presentation/screens/recipe_detail_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/saved_recipe.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/recipe_finder/application/recipe_providers.dart';
import 'package:neyese4/features/recipe_finder/presentation/screens/cooking_mode_screen.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/chef_tips_card.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/ingredients_card.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/nutrition_card.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/preparation_steps_card.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/recipe_title_and_meta_card.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/utensils_card.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final int recipeId;
  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsyncValue = ref.watch(fullRecipeProvider(recipeId));

    return recipeAsyncValue.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
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
                    errorBuilder: (c, e, s) => const Icon(Icons.error),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border_outlined,
                        color: isSaved ? AppColors.primaryAction : null),
                    onPressed: () {
                      final repository = ref.read(savedRecipeRepositoryProvider);
                      if (isSaved) {
                        repository.deleteRecipe(recipeId);
                      } else {
                        repository.saveRecipe(
                            SavedRecipe(id: recipeId, title: content.title, image: content.imageUrl));
                      }
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CookingModeScreen(
                      recipeTitle: content.title,
                      steps: content.preparationSteps,
                    ),
                  ),
                );
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