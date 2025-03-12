class DiseaseAnalysis {
  final String riskLevel;
  final String possibleDisease;
  final String description;
  final String prevention;
  final String firstAid;
  final String additionalAdvice;

  DiseaseAnalysis({
    required this.riskLevel,
    required this.possibleDisease,
    required this.description,
    required this.prevention,
    required this.firstAid,
    required this.additionalAdvice,
  });

  factory DiseaseAnalysis.fromRawString(String rawResponse) {
    // แยกบรรทัดของข้อความจาก API
    final lines = rawResponse.split('\n');
    
    // ฟังก์ชันสำหรับการสกัดค่าจากบรรทัด
    String extractValue(String line) {
      final parts = line.split(': ');
      if (parts.length < 2) return '';
      return parts.sublist(1).join(': ').trim();
    }

    // ค้นหาบรรทัดที่มีค่าที่ต้องการ
    String findLineStartingWith(String prefix) {
      final line = lines.firstWhere(
        (line) => line.startsWith(prefix),
        orElse: () => '',
      );
      return line.isEmpty ? '' : extractValue(line);
    }

    // สกัดค่าสำหรับแต่ละฟิลด์
    return DiseaseAnalysis(
      riskLevel: findLineStartingWith('ระดับความเสี่ยง'),
      possibleDisease: findLineStartingWith('โรคที่อาจเกิดขึ้น'),
      description: findLineStartingWith('คำอธิบาย'),
      prevention: findLineStartingWith('การป้องกัน'),
      firstAid: findLineStartingWith('การรักษาเบื้องต้น'),
      additionalAdvice: findLineStartingWith('คำแนะนำเพิ่มเติม'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'riskLevel': riskLevel,
      'possibleDisease': possibleDisease,
      'description': description,
      'prevention': prevention,
      'firstAid': firstAid,
      'additionalAdvice': additionalAdvice,
    };
  }

  factory DiseaseAnalysis.fromJson(Map<String, dynamic> json) {
    return DiseaseAnalysis(
      riskLevel: json['riskLevel'] ?? '',
      possibleDisease: json['possibleDisease'] ?? '',
      description: json['description'] ?? '',
      prevention: json['prevention'] ?? '',
      firstAid: json['firstAid'] ?? '',
      additionalAdvice: json['additionalAdvice'] ?? '',
    );
  }
}