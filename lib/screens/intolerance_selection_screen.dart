import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/user_preferences.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/profile/application/profile_providers.dart';

class IntoleranceSelectionScreen extends ConsumerWidget {
  const IntoleranceSelectionScreen({super.key});

  // Spoonacular API'nin desteklediği bazı yaygın hassasiyetler.
  final List<String> _intolerances = const [
    'Dairy',
    'Egg',
    'Gluten',
    'Grain',
    'Peanut',
    'Seafood',
    'Sesame',
    'Shellfish',
    'Soy',
    'Sulfite',
    'Tree Nut',
    'Wheat',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kullanıcının mevcut tercihlerini dinliyoruz.
    final currentPrefs = ref.watch(userPreferencesProvider);
    // Kayıtlı hassasiyetler listesini alıyoruz. Eğer boşsa, boş bir liste oluşturuyoruz.
    final selectedIntolerances = currentPrefs.intolerances ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerji ve Hassasiyetler'),
      ),
      body: ListView.builder(
        itemCount: _intolerances.length,
        itemBuilder: (context, index) {
          final intolerance = _intolerances[index];
          // O anki hassasiyetin, kullanıcının seçtiği listede olup olmadığını kontrol ediyoruz.
          final isSelected = selectedIntolerances.contains(intolerance);

          return CheckboxListTile(
            title: Text(intolerance, style: AppTextStyles.body),
            value: isSelected,
            onChanged: (bool? value) {
              if (value != null) {
                // Mevcut seçili listeyi düzenlenebilir bir kopyaya çeviriyoruz.
                final updatedList = List<String>.from(selectedIntolerances);

                if (value) {
                  // Eğer kutu işaretlendiyse, hassasiyeti listeye ekliyoruz.
                  updatedList.add(intolerance);
                } else {
                  // Eğer işaret kaldırıldıysa, hassasiyeti listeden çıkarıyoruz.
                  updatedList.remove(intolerance);
                }

                // Veritabanı repository'sine erişiyoruz.
                final repository = ref.read(userPreferencesRepositoryProvider);

                // Mevcut tercihlerin bir kopyasını oluşturup sadece hassasiyetler listesini güncelliyoruz.
                final updatedPrefs = UserPreferences(
                  diet: currentPrefs.diet,
                  intolerances: updatedList,
                );

                // Güncellenmiş tercihleri veritabanına kaydediyoruz.
                repository.savePreferences(updatedPrefs);
              }
            },
          );
        },
      ),
    );
  }
}
