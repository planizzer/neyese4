import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/recipe_finder/presentation/screens/recipe_detail_screen.dart';

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedRecipes = ref.watch(savedRecipesListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Kaydedilen Tariflerim')),
      body: savedRecipes.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bookmark_remove_outlined, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text('Henüz tarif kaydetmedin', style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Beğendiğin tariflerin detay sayfasındaki yer imi ikonuna dokunarak onları buraya ekleyebilirsin.', style: AppTextStyles.body.copyWith(color: Colors.grey[600]), textAlign: TextAlign.center),
            ],
          ),
        ),
      )
          : ListView.builder(
        itemCount: savedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = savedRecipes[index];
          final imageUrl = kIsWeb ? 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(recipe.image)}' : recipe.image;

          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported_outlined, size: 56, color: Colors.grey),
              ),
            ),
            title: Text(recipe.title, style: AppTextStyles.body),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipeId: recipe.id))),
          );
        },
      ),
    );
  }
}
