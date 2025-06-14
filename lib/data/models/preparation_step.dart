// lib/data/models/preparation_step.dart

class PreparationStep {
  final int stepNumber;
  final String description;
  final String? videoPrompt;

  PreparationStep({
    required this.stepNumber,
    required this.description,
    this.videoPrompt,
  });

  // YENİ EKLENDİ: fromJson metodu
  factory PreparationStep.fromJson(Map<String, dynamic> json) {
    return PreparationStep(
      stepNumber: json['step_number'] as int? ?? 0,
      description: json['description'] as String? ?? 'Adım açıklaması yok.',
      videoPrompt: json['video_prompt'] as String?,
    );
  }
}