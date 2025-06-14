// lib/features/recipe_finder/presentation/widgets/chef_tips_card.dart

import 'package:flutter/material.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/enriched_recipe_content.dart';

class ChefTipsCard extends StatelessWidget {
  final EnrichedRecipeContent content;
  const ChefTipsCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    if (content.chefTips.isEmpty) {
      // Eğer püf noktası yoksa, bu kartı hiç gösterme.
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryAction.withOpacity(0.05), // Farklı bir arka plan
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryAction.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: AppColors.primaryAction),
              const SizedBox(width: 8),
              Text('Püf Noktaları', style: AppTextStyles.h2),
            ],
          ),
          const SizedBox(height: 16),
          ...content.chefTips.map((tip) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              // İtalik ve hafif bir stil ile
              child: Text(
                '• $tip',
                style: AppTextStyles.body.copyWith(fontStyle: FontStyle.italic),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}