import 'package:flutter/material.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/enriched_recipe_content.dart';

class RecipeTitleAndMetaCard extends StatelessWidget {
  final EnrichedRecipeContent content;
  const RecipeTitleAndMetaCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(content.title, style: AppTextStyles.h1),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildInfoChip(
              icon: Icons.timer_outlined,
              label: '${content.readyInMinutes} dk',
            ),
            const SizedBox(width: 12),
            _buildInfoChip(
              icon: Icons.leaderboard_outlined,
              label: content.difficulty,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Chip(
      avatar: Icon(icon, color: AppColors.primaryAction, size: 20),
      label: Text(label),
      labelStyle: AppTextStyles.body.copyWith(color: AppColors.primaryText),
      backgroundColor: AppColors.primaryAction.withOpacity(0.1),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    );
  }
}