// lib/data/models/preparation_step.dart

class PreparationStep {
  final int stepNumber;                 // <-- TEKRAR EKLENDİ
  final String description;
  final List<String> stepIngredients;
  final String? videoPrompt;
  final String? imageUrl;
  final int? durationInSeconds;

  PreparationStep({
    required this.stepNumber,          // <-- TEKRAR EKLENDİ
    required this.description,
    this.stepIngredients = const [],
    this.videoPrompt,
    this.imageUrl,
    this.durationInSeconds,
  });

  factory PreparationStep.fromJson(Map<String, dynamic> json) {
    return PreparationStep(
      // Gelen 'step_number' alanını güvenli bir şekilde alıyoruz.
      // Eğer gelmezse varsayılan olarak 0 atar.
      stepNumber: json['step_number'] as int? ?? 0, // <-- TEKRAR EKLENDİ

      description: json['description'] as String? ?? 'Açıklama bulunamadı.',

      stepIngredients: (json['step_ingredients'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],

      videoPrompt: json['video_prompt'] as String?,
      imageUrl: json['imageUrl'] as String?,
      durationInSeconds: json['duration_in_seconds'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step_number': stepNumber, // <-- TEKRAR EKLENDİ
      'description': description,
      'step_ingredients': stepIngredients,
      'video_prompt': videoPrompt,
      'imageUrl': imageUrl,
      'duration_in_seconds': durationInSeconds,
    };
  }
}