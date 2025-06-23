// lib/features/recipe_finder/presentation/screens/cooking_mode_screen.dart

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neyese4/core/theme/app_colors.dart';
import 'package:neyese4/core/theme/app_text_styles.dart';
import 'package:neyese4/data/models/preparation_step.dart';
import 'package:neyese4/data/providers.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class CookingModeScreen extends ConsumerStatefulWidget {
  final String recipeTitle;
  final List<PreparationStep> steps;
  final String mainImageUrl;

  const CookingModeScreen({
    super.key,
    required this.recipeTitle,
    required this.steps,
    required this.mainImageUrl,
  });

  @override
  ConsumerState<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends ConsumerState<CookingModeScreen> {
  int _currentStepIndex = 0;
  final CountdownController _countdownController = CountdownController(autoStart: false);
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Zamanlayıcının süresini tutacak olan state değişkeni
  late int _currentDurationInSeconds;

  @override
  void initState() {
    super.initState();
    // Sayfa ilk açıldığında, ilk adımın süresini state'e ata
    _currentDurationInSeconds = widget.steps.first.durationInSeconds ?? 0;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    if (_currentStepIndex < widget.steps.length - 1) {
      ref.read(userXpProvider.notifier).state += 10;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('+10 XP Kazanıldı! 🎉'), duration: Duration(seconds: 1)),
        );
      }
      setState(() {
        _currentStepIndex++;
        // Bir sonraki adıma geçince süreyi state üzerinden güncelle
        _currentDurationInSeconds = widget.steps[_currentStepIndex].durationInSeconds ?? 0;
      });
      _countdownController.restart();
      _countdownController.pause();
    }
  }

  void _goToPreviousStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
        // Önceki adıma geçince süreyi state üzerinden güncelle
        _currentDurationInSeconds = widget.steps[_currentStepIndex].durationInSeconds ?? 0;
      });
      _countdownController.restart();
      _countdownController.pause();
    }
  }

  Future<void> _showSetTimerDialog() async {
    final minutesController = TextEditingController();
    final secondsController = TextEditingController();

    final resultInSeconds = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Zamanlayıcıyı Ayarla'),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: TextField(controller: minutesController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Dakika'))),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text(':')),
            Expanded(child: TextField(controller: secondsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Saniye'))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () {
              final minutes = int.tryParse(minutesController.text) ?? 0;
              final seconds = int.tryParse(secondsController.text) ?? 0;
              Navigator.of(context).pop(minutes * 60 + seconds);
            },
            child: const Text('Başlat'),
          ),
        ],
      ),
    );

    if (resultInSeconds != null && resultInSeconds > 0) {
      setState(() {
        // Kullanıcının girdiği süreyi state'e ata
        _currentDurationInSeconds = resultInSeconds;
      });
      // Zamanlayıcıyı yeni süreyle yeniden başlat
      _countdownController.restart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final PreparationStep currentStep = widget.steps[_currentStepIndex];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.recipeTitle, style: AppTextStyles.body.copyWith(fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(
              'Adım ${_currentStepIndex + 1}/${widget.steps.length}',
              style: AppTextStyles.caption.copyWith(color: AppColors.neutralGrey, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: currentStep.imageUrl ?? widget.mainImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: AppColors.primaryBackground),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.primaryBackground,
                    child: const Center(
                        child: Icon(Icons.restaurant_menu_outlined,
                            color: AppColors.neutralGrey, size: 48)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: _showSetTimerDialog,
              child: _buildTimerWidget(),
            ),

            if (currentStep.stepIngredients.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bu Adımın Malzemeleri:", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: currentStep.stepIngredients
                          .map((ingredient) => Chip(
                        label: Text(ingredient),
                        backgroundColor: AppColors.primaryBackground,
                        labelStyle: const TextStyle(color: AppColors.primaryText),
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    currentStep.description,
                    style: AppTextStyles.body.copyWith(fontSize: 20, height: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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
                  ref.read(userXpProvider.notifier).state += 50;
                  if(mounted){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tarif Tamamlandı! +50 XP Bonus! 🏆'), duration: Duration(seconds: 2)),
                    );
                    Navigator.of(context).pop();
                  }
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

  Widget _buildTimerWidget() {
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
              seconds: _currentDurationInSeconds,
              build: (_, double time) => Text(
                '${(time / 60).floor().toString().padLeft(2, '0')}:${(time % 60).floor().toString().padLeft(2, '0')}',
                style: AppTextStyles.h1.copyWith(fontFamily: 'monospace'),
              ),
              interval: const Duration(milliseconds: 100),
              onFinished: () {
                _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
                if(mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Süre doldu!')),
                  );
                }
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