// lib/features/recipe_finder/presentation/widgets/ingredients_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/enriched_recipe_content.dart';
import 'package:neyese4/data/models/ingredient_info.dart';

class IngredientsCard extends StatefulWidget {
  final EnrichedRecipeContent content;
  const IngredientsCard({super.key, required this.content});

  @override
  State<IngredientsCard> createState() => _IngredientsCardState();
}

class _IngredientsCardState extends State<IngredientsCard> {
  late int _servings;
  final int _originalServings = 2;

  // YENİ: İşaretlenmiş malzemelerin adlarını tutacak bir set.
  // Set kullanıyoruz çünkü her malzeme sadece bir kez eklenebilir.
  final Set<String> _checkedIngredients = {};

  @override
  void initState() {
    super.initState();
    _servings = _originalServings;
  }

  void _incrementServings() {
    setState(() {
      _servings++;
    });
  }

  void _decrementServings() {
    if (_servings > 1) {
      setState(() {
        _servings--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildStyledCard(
      title: 'Malzemeler',
      headerAccessory: _buildServingCalculator(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.content.ingredients.map((ingredient) {
          return _buildIngredientRow(ingredient);
        }).toList(),
      ),
    );
  }

  Widget _buildServingCalculator() {
    return Row(
      children: [
        IconButton(
          onPressed: _decrementServings,
          icon: const Icon(Icons.remove_circle_outline),
          color: AppColors.neutralGrey,
        ),
        Text('$_servings Porsiyon', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        IconButton(
          onPressed: _incrementServings,
          icon: const Icon(Icons.add_circle_outline),
          color: AppColors.primaryAction,
        ),
      ],
    );
  }

  // GÜNCELLENDİ: Bu metot artık interaktif bir Checkbox içeriyor.
  Widget _buildIngredientRow(IngredientInfo ingredient) {
    final newAmount = (ingredient.amount / _originalServings) * _servings;
    final NumberFormat numberFormat = NumberFormat("#.##");
    final formattedAmount = numberFormat.format(newAmount);

    // Bu malzemenin işaretli olup olmadığını kontrol ediyoruz.
    final bool isChecked = _checkedIngredients.contains(ingredient.name);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: InkWell( // Tüm satırı tıklanabilir yapmak için
        onTap: () {
          setState(() {
            if (isChecked) {
              _checkedIngredients.remove(ingredient.name);
            } else {
              _checkedIngredients.add(ingredient.name);
            }
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              // GÜNCELLENDİ: Artık statik bir ikon yerine interaktif bir Checkbox var.
              Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _checkedIngredients.add(ingredient.name);
                    } else {
                      _checkedIngredients.remove(ingredient.name);
                    }
                  });
                },
                activeColor: AppColors.primaryAction,
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: Text(
                  '$formattedAmount ${ingredient.unit}',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  ingredient.name,
                  // GÜNCELLENDİ: İşaretliyse metnin üzerini çiziyoruz.
                  style: AppTextStyles.body.copyWith(
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                    color: isChecked ? AppColors.neutralGrey : AppColors.primaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledCard({required String title, required Widget child, Widget? headerAccessory}) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.h2),
              if (headerAccessory != null) headerAccessory,
            ],
          ),
          const Divider(height: 32),
          child,
        ],
      ),
    );
  }
}