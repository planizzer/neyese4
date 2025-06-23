// lib/screens/diet_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/user_preferences.dart';
import 'package:neyese4/data/providers.dart';

class DietSelectionScreen extends ConsumerWidget {
  const DietSelectionScreen({super.key});

  // YENİ YAPI: Anahtar (İngilizce API değeri) ve Değer (Türkçe UI metni)
  // 'null' anahtarı, "Hiçbiri" seçeneğini temsil eder.
  static const Map<String?, String> _dietsMap = {
    null: 'Hiçbiri (Varsayılan)',
    'Gluten Free': 'Glutensiz',
    'Ketogenic': 'Ketojenik',
    'Vegetarian': 'Vejetaryen',
    'Lacto-Vegetarian': 'Lakto-Vejetaryen',
    'Ovo-Vegetarian': 'Ovo-Vejetaryen',
    'Vegan': 'Vegan',
    'Pescetarian': 'Pescetarian',
    'Paleo': 'Paleo',
    'Primal': 'Primal',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPrefs = ref.watch(userPreferencesProvider);

    // Haritanın anahtar ve değerlerini kolay erişim için listelere çeviriyoruz.
    final dietKeys = _dietsMap.keys.toList();
    final dietValues = _dietsMap.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diyet Tercihini Seç'),
      ),
      body: ListView.builder(
        itemCount: dietValues.length,
        itemBuilder: (context, index) {
          final turkishName = dietValues[index];
          final englishKey = dietKeys[index];

          return RadioListTile<String?>(
            title: Text(turkishName, style: AppTextStyles.body),
            // 'groupValue', o an seçili olan değeri belirtir.
            groupValue: currentPrefs.diet,
            // Bu radyo butonunun temsil ettiği değer.
            value: englishKey,
            // Bir seçim yapıldığında çalışacak fonksiyon.
            onChanged: (String? value) {
              final repository = ref.read(userPreferencesRepositoryProvider);

              // Mevcut tercihlerin bir kopyasını oluşturup sadece diyet alanını güncelliyoruz.
              final updatedPrefs = UserPreferences(
                diet: value, // Seçilen yeni İngilizce anahtarı ata
                intolerances: currentPrefs.intolerances,
                equipment: currentPrefs.equipment,
              );

              // Güncellenmiş tercihleri veritabanına kaydediyoruz.
              repository.savePreferences(updatedPrefs);
            },
          );
        },
      ),
    );
  }
}