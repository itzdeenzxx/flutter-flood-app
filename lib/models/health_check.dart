// models/health_check.dart
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

  // คำนวณระดับความเสี่ยง
  String getRiskLevel() {
    int score = 0;
    if (hasFever) score += 3;
    if (hasCough) score += 2;
    if (hasSkinRash) score += 2;
    if (hasDiarrhea) score += 3;
    if (hasWaterContamination) score += 4;

    if (score >= 8) return 'สูง';
    if (score >= 5) return 'ปานกลาง';
    return 'ต่ำ';
  }
}