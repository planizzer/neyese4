// lib/screens/recipes_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/recipe_card.dart'; // Yeni kartımızı import ediyoruz

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedRecipes = ref.watch(savedRecipesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kaydedilen Tariflerim')),
      body: savedRecipes.isEmpty
          ? Center( // Boş durum için daha şık bir arayüz
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bookmark_remove_outlined, size: 100, color: Colors.grey[300]),
              const SizedBox(height: 24),
              const Text('Henüz Tarif Kaydetmedin', style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'Beğendiğin tariflerin detay sayfasındaki yer imi ikonuna dokunarak onları buraya ekleyebilirsin.',
                style: AppTextStyles.body.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )
          : GridView.builder( // ListView yerine GridView kullanıyoruz
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Yan yana 2 kart
          crossAxisSpacing: 16, // Yatay boşluk
          mainAxisSpacing: 16, // Dikey boşluk
          childAspectRatio: 0.75, // Kartların en-boy oranı
        ),
        itemCount: savedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = savedRecipes.reversed.toList()[index];
          return RecipeCard( // Yeniden kullanılabilir kartımızı çağırıyoruz
            recipe: RecipeSuggestion(id: recipe.id, title: recipe.title, image: recipe.image),
          );
        },
      ),
    );
  }
}