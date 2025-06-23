import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/recipe_suggestion.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/recipe_finder/application/search_query.dart';
import 'package:neyese4/features/recipe_finder/presentation/screens/recipe_results_screen.dart';
import 'package:neyese4/features/recipe_finder/presentation/widgets/recipe_card.dart';
import 'package:neyese4/core/widgets/chef_loading_indicator.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

// lib/screens/home_screen.dart

  void _findRecipes() {
    final rawQuery = _searchController.text.trim();
    if (rawQuery.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir arama terimi veya malzeme girin.')),
      );
      return;
    }

    final userPrefs = ref.read(userPreferencesProvider);
    SearchQuery searchQuery;

    // Virgül veya boşlukla ayrılmış kelimeleri malzeme olarak kabul et.
    final ingredients = rawQuery
        .replaceAll(',', ' ') // Virgülleri boşluğa çevir
        .split(' ')          // Boşluklara göre ayır
        .map((e) => e.trim())  // Başındaki/sonundaki boşlukları temizle
        .where((e) => e.isNotEmpty) // Boş elemanları kaldır
        .toList();

    // Eğer birden fazla kelime varsa veya tek kelime ama malzeme gibi görünüyorsa
    // malzeme araması yap. Şimdilik basitçe, her zaman malzeme araması yapabiliriz.
    searchQuery = SearchQuery(
      ingredients: ingredients,
      diet: userPrefs.diet,
      intolerances: userPrefs.intolerances,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecipeResultsScreen(searchQuery: searchQuery),
      ),
    );
  }

  void _findRecipesFromMyKitchen() {
    // GÜNCELLENDİ: pantryBoxProvider kullanılıyor
    final pantryBox = ref.read(pantryBoxProvider);
    // GÜNCELLENDİ: .productName kullanılıyor
    final myIngredients = pantryBox.values.map((e) => e.productName).toList();

    if (myIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Önce "Mutfağım" sekmesinden malzeme eklemelisiniz.')));
      return;
    }

    final userPrefs = ref.read(userPreferencesProvider);
    final searchQuery = SearchQuery(ingredients: myIngredients, diet: userPrefs.diet, intolerances: userPrefs.intolerances);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipeResultsScreen(searchQuery: searchQuery)));
  }

  @override
  Widget build(BuildContext context) {
    final dinnerIdeasAsyncValue = ref.watch(dinnerIdeasProvider);
    final randomRecipesAsyncValue = ref.watch(randomRecipesProvider);
    // GÜNCELLENDİ: pantryBoxProvider kullanılıyor
    final pantryBox = ref.watch(pantryBoxProvider);
    final myPantryItems = pantryBox.values.toList();


    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0, bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSearchSection(),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildMyKitchenSection(myPantryItems), // GÜNCELLENDİ
              ),
              const SizedBox(height: 40),
              _buildCategoriesSection(),
              const SizedBox(height: 40),Consumer(
                builder: (context, ref, child) {
                  // Artık Firestore'dan gelen anlık Stream'i dinliyoruz.
                  final savedRecipesAsync = ref.watch(savedRecipesStreamProvider);

                  // Stream'in durumuna göre arayüzü çiziyoruz.
                  return savedRecipesAsync.when(
                    loading: () => const SizedBox.shrink(), // Yüklenirken hiçbir şey gösterme
                    error: (e, s) => const SizedBox.shrink(), // Hata olursa hiçbir şey gösterme
                    data: (recipes) {
                      // Eğer hiç kaydedilmiş tarif yoksa, bölümü hiç çizme
                      if (recipes.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      // Tarifler varsa, karuseli _buildRecipeCarousel ile çiz
                      return _buildRecipeCarousel(
                        title: 'Son Kaydettiklerin',
                        recipes: recipes.reversed.map((e) => RecipeSuggestion(id: e.id, title: e.title, image: e.image)).toList(),
                      );
                    },
                  );
                },
              ),
              _buildRecipeCarousel(title: 'Akşam Yemeği Fikirleri', asyncValue: dinnerIdeasAsyncValue),
              _buildRecipeCarousel(title: 'Günün Önerileri', asyncValue: randomRecipesAsyncValue),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDER METOTLARI ---

  Widget _buildMyKitchenSection(List<dynamic> ingredients) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mutfağımdakilerle Tarif Bul', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              ingredients.isEmpty
                  ? 'Mutfağınızda henüz malzeme yok. Eklemeye başlayın!'
              // GÜNCELLENDİ: .productName kullanılıyor
                  : '${ingredients.length} malzemeniz var: ${ingredients.take(3).map((e) => e.productName).join(', ')}...',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _findRecipesFromMyKitchen,
                icon: const Icon(Icons.search),
                label: const Text('Tüm Malzemelerimle Ara'),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppColors.primaryAction),
                    foregroundColor: AppColors.primaryAction,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bugün ne yesek?', style: AppTextStyles.h1),
          const SizedBox(height: 8),
          const Text('İstediğin tarifi veya elindeki malzemeleri yaz.', style: AppTextStyles.body),
          const SizedBox(height: 24),
          TextField(
            controller: _searchController,
            style: AppTextStyles.input,
            decoration: InputDecoration(
              hintText: 'Tavuk, Pilav veya Menemen...',
              prefixIcon: const Icon(Icons.search, color: AppColors.neutralGrey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            onSubmitted: (_) => _findRecipes(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _findRecipes,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAction,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  shadowColor: AppColors.primaryAction.withOpacity(0.4)
              ),
              child: const Text('Tarif Bul', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCategoriesSection() {
    final Map<String, IconData> categoryIcons = {
      'Kahvaltı': Icons.free_breakfast_outlined, 'Tatlı': Icons.cake_outlined, 'Salata': Icons.restaurant_outlined,
      'İtalyan': Icons.local_pizza_outlined, 'Vegan': Icons.eco_outlined, 'Hızlı Tarifler': Icons.timer_outlined,
    };
    final Map<String, SearchQuery> categoryMapping = {
      'Kahvaltı': const SearchQuery(type: 'breakfast'), 'Tatlı': const SearchQuery(type: 'dessert'),
      'Salata': const SearchQuery(type: 'salad'), 'İtalyan': const SearchQuery(cuisine: 'italian'),
      'Vegan': const SearchQuery(diet: 'vegan'), 'Hızlı Tarifler': const SearchQuery(maxReadyTime: 30),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text('Kategorileri Keşfet', style: AppTextStyles.h2),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: categoryMapping.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final categoryName = categoryMapping.keys.elementAt(index);
              final searchQuery = categoryMapping.values.elementAt(index);
              return ActionChip(
                avatar: Icon(categoryIcons[categoryName] ?? Icons.circle, size: 18, color: AppColors.primaryText),
                label: Text(categoryName),
                labelStyle: AppTextStyles.body.copyWith(fontSize: 14),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: AppColors.neutralGrey.withOpacity(0.3))),
                onPressed: () {
                  final userPrefs = ref.read(userPreferencesProvider);
                  final finalQuery = searchQuery.copyWith(diet: userPrefs.diet, intolerances: userPrefs.intolerances);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RecipeResultsScreen(searchQuery: finalQuery),
                  ));
                },
              );
            },
          ),
        ),
      ],
    );
  }


  Widget _buildRecipeCarousel({
    required String title,
    List<RecipeSuggestion>? recipes,
    AsyncValue<List<RecipeSuggestion>>? asyncValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(title, style: AppTextStyles.h2),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: asyncValue != null
              ? asyncValue.when(
            data: (recipes) => _buildCarouselListView(recipes),
            loading: () => Center(child: ChefLoadingIndicator()),
            error: (err, stack) => Center(child: Text('Öneriler yüklenemedi: $err')),
          )
              : _buildCarouselListView(recipes ?? []),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCarouselListView(List<RecipeSuggestion> recipes) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: recipes.length,
      padding: const EdgeInsets.only(left: 24.0, right: 8.0),
      itemBuilder: (context, index) => RecipeCard(recipe: recipes[index]),
    );
  }

}