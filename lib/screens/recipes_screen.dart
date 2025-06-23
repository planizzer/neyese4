// lib/screens/recipes_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/recipe_card.dart';
import 'package:neyese4/core/widgets/chef_loading_indicator.dart';

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Yeni StreamProvider'ımızı dinliyoruz.
    final savedRecipesAsyncValue = ref.watch(savedRecipesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kaydedilen Tariflerim')),
      // Stream'in durumuna göre (yükleniyor, hata, veri geldi) arayüzü çiziyoruz.
      body: savedRecipesAsyncValue.when(
        loading: () => Center(child: ChefLoadingIndicator()),
        error: (err, stack) => Center(child: Text('Tarifler yüklenemedi: $err')),
        data: (savedRecipes) {
          if (savedRecipes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_remove_outlined, size: 100, color: Colors.grey[300]),
                    const SizedBox(height: 24),
                    const Text('Henüz Tarif Kaydetmedin', style: AppTextStyles.h2, textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }
          // Veri geldiğinde GridView'ı oluştur.
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: savedRecipes.length,
            itemBuilder: (context, index) {
              final recipe = savedRecipes[index];
              return RecipeCard(
                recipe: RecipeSuggestion(id: recipe.id, title: recipe.title, image: recipe.image),
              );
            },
          );
        },
      ),
    );
  }
}