import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/recipe_finder/presentation/screens/recipe_detail_screen.dart';

// Sayfamızı ConsumerWidget'a dönüştürüyoruz ki provider'ları dinleyebilelim.
class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kaydedilmiş tariflerin güncel listesini dinliyoruz.
    final savedRecipes = ref.watch(savedRecipesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaydedilen Tariflerim'),
      ),
      body:
      // Eğer hiç kaydedilmiş tarif yoksa, kullanıcıya bir mesaj gösteriyoruz.
      savedRecipes.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bookmark_remove_outlined, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                'Henüz tarif kaydetmedin',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
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
      // Eğer kaydedilmiş tarifler varsa, onları bir liste halinde gösteriyoruz.
          : ListView.builder(
        itemCount: savedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = savedRecipes[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                recipe.image,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(recipe.title, style: AppTextStyles.body),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Listedeki bir tarife tıklandığında detay sayfasına yönlendiriyoruz.
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipeId: recipe.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
