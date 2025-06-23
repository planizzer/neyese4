// lib/screens/intolerance_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/user_preferences.dart';
import 'package:neyese4/data/providers.dart';

class IntoleranceSelectionScreen extends ConsumerWidget {
  const IntoleranceSelectionScreen({super.key});

  // YENİ YAPI: Anahtar (İngilizce API değeri) ve Değer (Türkçe UI metni)
  static const Map<String, String> _intolerancesMap = {
    'Dairy': 'Süt Ürünleri',
    'Egg': 'Yumurta',
    'Gluten': 'Gluten',
    'Grain': 'Tahıl',
    'Peanut': 'Yer Fıstığı',
    'Seafood': 'Deniz Mahsulleri',
    'Sesame': 'Susam',
    'Shellfish': 'Kabuklu Deniz Ürünleri',
    'Soy': 'Soya',
    'Sulfite': 'Sülfit',
    'Tree Nut': 'Ağaç Fıstığı',
    'Wheat': 'Buğday',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPrefs = ref.watch(userPreferencesProvider);
    // Kayıtlı olanlar hala İngilizce anahtarlar
    final selectedIntolerances = currentPrefs.intolerances ?? [];

    // Ekranda göstermek için Türkçe değerleri ve İngilizce anahtarları listeye çeviriyoruz
    final intoleranceKeys = _intolerancesMap.keys.toList();
    final intoleranceValues = _intolerancesMap.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerji ve Hassasiyetler'),
      ),
      body: ListView.builder(
        itemCount: intoleranceValues.length,
        itemBuilder: (context, index) {
          final turkishName = intoleranceValues[index];
          final englishKey = intoleranceKeys[index];
          // Seçili olup olmadığını İngilizce anahtara göre kontrol ediyoruz
          final isSelected = selectedIntolerances.contains(englishKey);

          return CheckboxListTile(
            title: Text(turkishName, style: AppTextStyles.body),
            value: isSelected,
            onChanged: (bool? value) {
              if (value != null) {
                final updatedList = List<String>.from(selectedIntolerances);

                if (value) {
                  // Seçildiğinde listeye İngilizce anahtarı ekle
                  updatedList.add(englishKey);
                } else {
                  // Seçim kaldırıldığında listeden İngilizce anahtarı çıkar
                  updatedList.remove(englishKey);
                }

                final repository = ref.read(userPreferencesRepositoryProvider);
                final updatedPrefs = UserPreferences(
                  diet: currentPrefs.diet,
                  intolerances: updatedList,
                  equipment: currentPrefs.equipment,
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