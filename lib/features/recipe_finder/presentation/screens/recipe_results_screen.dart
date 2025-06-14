import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/features/recipe_finder/application/recipe_providers.dart';
import 'package:neyese4/features/recipe_finder/application/search_query.dart';
import 'package:neyese4/features/recipe_finder/presentation/screens/recipe_detail_screen.dart';

class RecipeResultsScreen extends ConsumerWidget {
  final SearchQuery searchQuery;

  const RecipeResultsScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsyncValue = ref.watch(recipesByIngredientsProvider(searchQuery));
    return Scaffold(
      appBar: AppBar(title: Text('${searchQuery.ingredients.join(', ')} için Tarifler')),
      body: resultsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata oluştu: $err')),
        data: (recipes) {
          if (recipes.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Bu kriterlere uygun tarif bulunamadı.', style: AppTextStyles.body, textAlign: TextAlign.center),
              ),
            );
          }
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              final imageUrl = kIsWeb ? 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(recipe.image)}' : recipe.image;

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported_outlined, size: 70, color: Colors.grey),
                  ),
                ),
                title: Text(recipe.title, style: AppTextStyles.body),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipeId: recipe.id))),
              );
            },
          );
        },
      ),
    );
  }
}
