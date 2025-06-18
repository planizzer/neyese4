class PreparationStep {
  final int stepNumber;
  final String description;
  final String? videoPrompt;
  final int? durationInSeconds; // YENİ: Saniye cinsinden süre

  PreparationStep({
    required this.stepNumber,
    required this.description,
    this.videoPrompt,
    this.durationInSeconds, // YENİ
  });

  factory PreparationStep.fromJson(Map<String, dynamic> json) {
    return PreparationStep(
      stepNumber: json['step_number'] as int? ?? 0,
      description: json['description'] as String? ?? 'Adım açıklaması yok.',
      videoPrompt: json['video_prompt'] as String?,
      durationInSeconds: json['duration_in_seconds'] as int?, // YENİ
    );
  }
}