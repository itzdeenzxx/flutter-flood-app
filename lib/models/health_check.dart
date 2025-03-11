class HealthCheck {
  final String id;
  final DateTime date;
  final bool hasFever;
  final bool hasCough;
  final bool hasSkinRash;
  final bool hasDiarrhea;
  final bool hasWaterContamination;
  final String? additionalNotes;

  HealthCheck({
    required this.id,
    required this.date,
    required this.hasFever,
    required this.hasCough,
    required this.hasSkinRash,
    required this.hasDiarrhea,
    required this.hasWaterContamination,
    this.additionalNotes,
  });

  factory HealthCheck.fromJson(Map<String, dynamic> json) {
    return HealthCheck(
      id: json['id'],
      date: DateTime.parse(json['date']),
      hasFever: json['hasFever'],
      hasCough: json['hasCough'],
      hasSkinRash: json['hasSkinRash'],
      hasDiarrhea: json['hasDiarrhea'],
      hasWaterContamination: json['hasWaterContamination'],
      additionalNotes: json['additionalNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'hasFever': hasFever,
      'hasCough': hasCough,
      'hasSkinRash': hasSkinRash,
      'hasDiarrhea': hasDiarrhea,
      'hasWaterContamination': hasWaterContamination,
      'additionalNotes': additionalNotes,
    };
  }

  int getRiskScore() {
    int score = 0;
    if (hasFever) score += 2;
    if (hasCough) score += 1;
    if (hasSkinRash) score += 2;
    if (hasDiarrhea) score += 3;
    if (hasWaterContamination) score += 2;
    return score;
  }

  String getRiskLevel() {
    int score = getRiskScore();
    if (score <= 2) return 'ต่ำ';
    if (score <= 5) return 'ปานกลาง';
    return 'สูง';
  }
}