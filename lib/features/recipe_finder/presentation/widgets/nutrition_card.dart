// lib/features/recipe_finder/presentation/widgets/nutrition_card.dart

import 'package:flutter/material.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/enriched_recipe_content.dart';

class NutritionCard extends StatelessWidget {
  final EnrichedRecipeContent content;
  const NutritionCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return _buildStyledCard(
      title: 'Tahmini Besin Değerleri',
      child: Column(
        children: content.estimatedNutrition.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key, style: AppTextStyles.body),
                Text(entry.value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Ortak kart stili için yardımcı metot.
  Widget _buildStyledCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h2),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}