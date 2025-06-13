import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/user_preferences.dart'; // UserPreferences modelini import ediyoruz.
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/profile/application/profile_providers.dart';

class DietSelectionScreen extends ConsumerWidget {
  const DietSelectionScreen({super.key});

  final List<String> _diets = const [
    'None', // Hiçbiri
    'Gluten Free',
    'Ketogenic',
    'Vegetarian',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Vegan',
    'Pescetarian',
    'Paleo',
    'Primal',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPrefs = ref.watch(userPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diyet Tercihini Seç'),
      ),
      body: ListView.builder(
        itemCount: _diets.length,
        itemBuilder: (context, index) {
          final diet = _diets[index];
          final isSelected = (diet == 'None' && currentPrefs.diet == null) || currentPrefs.diet == diet;

          return RadioListTile<String>(
            title: Text(diet, style: AppTextStyles.body),
            value: diet,
            groupValue: currentPrefs.diet ?? 'None',
            onChanged: (String? value) {
              if (value != null) {
                final newDiet = value == 'None' ? null : value;
                final repository = ref.read(userPreferencesRepositoryProvider);

                // DÜZELTME: 'copyWith' yerine yeni bir UserPreferences nesnesi oluşturuyoruz.
                // Bu, mevcut 'intolerances' (alerjiler) listesini korurken
                // sadece 'diet' alanını günceller.
                final updatedPrefs = UserPreferences(
                  diet: newDiet,
                  intolerances: currentPrefs.intolerances,
                );

                repository.savePreferences(updatedPrefs);
              }
            },
          );
        },
      ),
    );
  }
}
