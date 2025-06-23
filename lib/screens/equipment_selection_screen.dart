// lib/screens/equipment_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/user_preferences.dart';
import 'package:neyese4/data/providers.dart';

class EquipmentSelectionScreen extends ConsumerWidget {
  const EquipmentSelectionScreen({super.key});

  // YENİ YAPI: Map<String, String>
  static const Map<String, String> _equipmentMap = {
    'Oven': 'Fırın',
    'Microwave': 'Mikrodalga Fırın',
    'Blender': 'Blender',
    'Mixer': 'Mikser',
    'Food Processor': 'Mutfak Robotu',
    'Air Fryer': 'Air Fryer (Sıcak Hava Fritözü)',
    'Slow Cooker': 'Yavaş Pişirici',
    'Grill': 'Izgara',
    'Pressure Cooker': 'Düdüklü Tencere',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPrefs = ref.watch(userPreferencesProvider);
    final selectedEquipment = currentPrefs.equipment ?? [];

    final equipmentKeys = _equipmentMap.keys.toList();
    final equipmentValues = _equipmentMap.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutfak Aletleri'),
      ),
      body: ListView.builder(
        itemCount: equipmentValues.length,
        itemBuilder: (context, index) {
          final turkishName = equipmentValues[index];
          final englishKey = equipmentKeys[index];
          final isSelected = selectedEquipment.contains(englishKey);

          return CheckboxListTile(
            title: Text(turkishName, style: AppTextStyles.body),
            value: isSelected,
            onChanged: (bool? value) {
              if (value != null) {
                final updatedList = List<String>.from(selectedEquipment);

                if (value) {
                  updatedList.add(englishKey);
                } else {
                  updatedList.remove(englishKey);
                }

                final repository = ref.read(userPreferencesRepositoryProvider);
                final updatedPrefs = UserPreferences(
                  diet: currentPrefs.diet,
                  intolerances: currentPrefs.intolerances,
                  equipment: updatedList,
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