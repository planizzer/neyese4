// lib/features/recipe_finder/presentation/screens/cooking_mode_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // YENİ: Riverpod importu
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/preparation_step.dart';
import 'package:neyese4/features/profile/application/xp_provider.dart'; // YENİ: XP Provider importu
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

// GÜNCELLENDİ: StatefulWidget -> ConsumerStatefulWidget
class CookingModeScreen extends ConsumerStatefulWidget {
  final String recipeTitle;
  final List<PreparationStep> steps;

  const CookingModeScreen({
    super.key,
    required this.recipeTitle,
    required this.steps,
  });

  @override
  // GÜNCELLENDİ: State -> ConsumerState
  ConsumerState<CookingModeScreen> createState() => _CookingModeScreenState();
}

// GÜNCELLENDİ: State -> ConsumerState
class _CookingModeScreenState extends ConsumerState<CookingModeScreen> {
  int _currentStepIndex = 0;
  final CountdownController _countdownController = CountdownController(autoStart: false);

  void _goToNextStep() {
    if (_currentStepIndex < widget.steps.length - 1) {
      // YENİ: Her adım geçildiğinde 10 XP kazan
      ref.read(userXpProvider.notifier).state += 10;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('+10 XP Kazanıldı! 🎉'), duration: Duration(seconds: 1)),
      );

      setState(() {
        _currentStepIndex++;
        _countdownController.restart();
        _countdownController.pause();
      });
    }
  }

  void _goToPreviousStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
        _countdownController.restart();
        _countdownController.pause();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final PreparationStep currentStep = widget.steps[_currentStepIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${_currentStepIndex + 1}. Adım / ${widget.steps.length}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // ... body kısmı aynı ...
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.videocam_outlined, color: AppColors.neutralGrey, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (currentStep.durationInSeconds != null)
              _buildTimerWidget(currentStep.durationInSeconds!),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    currentStep.description,
                    style: AppTextStyles.body.copyWith(fontSize: 20, height: 1.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Opacity(
              opacity: _currentStepIndex > 0 ? 1.0 : 0.0,
              child: ElevatedButton.icon(
                onPressed: _currentStepIndex > 0 ? _goToPreviousStep : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Önceki'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (_currentStepIndex == widget.steps.length - 1) {
                  // YENİ: Tarifi bitirince 50 XP bonus kazan
                  ref.read(userXpProvider.notifier).state += 50;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tarif Tamamlandı! +50 XP Bonus! 🏆'), duration: Duration(seconds: 2)),
                  );
                  Navigator.of(context).pop();
                } else {
                  _goToNextStep();
                }
              },
              icon: Icon(_currentStepIndex == widget.steps.length - 1 ? Icons.check_circle : Icons.arrow_forward),
              label: Text(_currentStepIndex == widget.steps.length - 1 ? 'Tarifi Bitir' : 'Sonraki'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // _buildTimerWidget metodu aynı
  Widget _buildTimerWidget(int seconds) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Countdown(
              controller: _countdownController,
              seconds: seconds,
              build: (_, double time) => Text(
                '${(time / 60).floor().toString().padLeft(2, '0')}:${(time % 60).floor().toString().padLeft(2, '0')}',
                style: AppTextStyles.h1.copyWith(fontFamily: 'monospace'),
              ),
              interval: const Duration(milliseconds: 100),
              onFinished: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Süre doldu!')),
                );
              },
            ),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.play_arrow, color: AppColors.accent),onPressed: () => _countdownController.resume()),
                IconButton(icon: const Icon(Icons.pause, color: AppColors.primaryAction),onPressed: () => _countdownController.pause()),
                IconButton(icon: const Icon(Icons.replay, color: AppColors.neutralGrey),onPressed: () => _countdownController.restart()),
              ],
            )
          ],
        ),
      ),
    );
  }
}