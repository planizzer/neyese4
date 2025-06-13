import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/user_preferences.dart';
import 'package:neyese4/data/providers.dart';
import 'package:neyese4/features/profile/application/profile_providers.dart';

class EquipmentSelectionScreen extends ConsumerWidget {
  const EquipmentSelectionScreen({super.key});

  // Yaygın mutfak aletleri listesi.
  final List<String> _equipment = const [
    'Oven',
    'Microwave',
    'Blender',
    'Mixer',
    'Food Processor',
    'Air Fryer',
    'Slow Cooker',
    'Grill',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPrefs = ref.watch(userPreferencesProvider);
    final selectedEquipment = currentPrefs.equipment ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutfak Aletleri'),
      ),
      body: ListView.builder(
        itemCount: _equipment.length,
        itemBuilder: (context, index) {
          final equipmentItem = _equipment[index];
          final isSelected = selectedEquipment.contains(equipmentItem);

          return CheckboxListTile(
            title: Text(equipmentItem, style: AppTextStyles.body),
            value: isSelected,
            onChanged: (bool? value) {
              if (value != null) {
                final updatedList = List<String>.from(selectedEquipment);

                if (value) {
                  updatedList.add(equipmentItem);
                } else {
                  updatedList.remove(equipmentItem);
                }

                final repository = ref.read(userPreferencesRepositoryProvider);

                // Mevcut tercihlerin kopyasını oluşturup sadece aletler listesini güncelliyoruz.
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
