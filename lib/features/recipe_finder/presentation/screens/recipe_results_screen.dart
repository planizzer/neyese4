import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/features/recipe_finder/application/recipe_providers.dart';
import 'package:neyese4/features/recipe_finder/presentation/screens/recipe_detail_screen.dart';

// Bu sayfa, hangi malzemelerin arandığını bilmek için bir liste alır.
class RecipeResultsScreen extends ConsumerWidget {
  final List<String> ingredients;

  const RecipeResultsScreen({
    super.key,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Malzemelere göre arama yapan provider'ımızı dinliyoruz.
    final resultsAsyncValue = ref.watch(recipesByIngredientsProvider(ingredients));

    return Scaffold(
      appBar: AppBar(
        // Başlıkta aranan malzemeleri gösteriyoruz.
        title: Text('${ingredients.join(', ')} için Tarifler'),
      ),
      body: resultsAsyncValue.when(
        // Veri yüklenirken animasyon gösteriyoruz.
        loading: () => const Center(child: CircularProgressIndicator()),
        // Hata oluşursa mesaj gösteriyoruz.
        error: (err, stack) => Center(child: Text('Hata oluştu: $err')),
        // Veri başarıyla geldiğinde listeyi oluşturuyoruz.
        data: (recipes) {
          // Eğer hiç tarif bulunamadıysa kullanıcıyı bilgilendiriyoruz.
          if (recipes.isEmpty) {
            return const Center(
              child: Text(
                'Bu malzemelerle tarif bulunamadı.',
                style: AppTextStyles.body,
              ),
            );
          }
          // Tarifler bulunduysa, ListView ile listeliyoruz.
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    recipe.image,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(recipe.title, style: AppTextStyles.body),
                // Tarif detayına gitmek için tıklama özelliği.
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailScreen(recipeId: recipe.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
