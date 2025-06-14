// lib/features/recipe_finder/presentation/widgets/preparation_steps_card.dart

import 'package:flutter/material.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/enriched_recipe_content.dart';
import 'package:neyese4/data/models/preparation_step.dart';

class PreparationStepsCard extends StatelessWidget {
  final EnrichedRecipeContent content;
  const PreparationStepsCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return _buildStyledCard(
      title: 'Hazırlanışı',
      child: Column(
        children: content.preparationSteps.map((step) {
          // Her bir adım için _StepItem widget'ını oluşturuyoruz.
          // Listenin son elemanı değilse, altına bir ayırıcı (divider) ekliyoruz.
          final isLastItem = step == content.preparationSteps.last;
          return Column(
            children: [
              _StepItem(step: step),
              if (!isLastItem)
                const Divider(height: 32, thickness: 0.5)
            ],
          );
        }).toList(),
      ),
    );
  }

  // Diğer kartlarımızla aynı stili kullanmak için yardımcı metot.
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

// Tek bir hazırlık adımını gösteren widget.
class _StepItem extends StatelessWidget {
  final PreparationStep step;
  const _StepItem({required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Adım Numarası
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.primaryAction,
          child: Text(
            '${step.stepNumber}',
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Adım Açıklaması ve Görseli için Alan
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.description,
                style: AppTextStyles.body.copyWith(height: 1.5, fontSize: 17),
              ),
              const SizedBox(height: 16),
              // Gelecekte AI ile görsel üreteceğimiz alanın yer tutucusu.
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.neutralGrey,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}