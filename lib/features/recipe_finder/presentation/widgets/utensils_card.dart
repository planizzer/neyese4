import 'package:flutter/material.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/enriched_recipe_content.dart';

class UtensilsCard extends StatelessWidget {
  final EnrichedRecipeContent content;
  const UtensilsCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return _buildStyledCard(
      title: 'Mutfak Aletleri',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.requiredUtensils.map((utensil) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text('• $utensil', style: AppTextStyles.body),
          );
        }).toList(),
      ),
    );
  }

  // Ortak kart stilimizi oluşturmak için bir yardımcı metot
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