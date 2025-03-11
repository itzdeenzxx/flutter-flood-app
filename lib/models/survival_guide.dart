class SurvivalGuide {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final List<SurvivalStep> steps;
  final String category;
  final int importance; // 1-5 scale

  SurvivalGuide({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.steps,
    required this.category,
    required this.importance,
  });

  factory SurvivalGuide.fromJson(Map<String, dynamic> json) {
    return SurvivalGuide(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconPath: json['iconPath'],
      steps: (json['steps'] as List)
          .map((step) => SurvivalStep.fromJson(step))
          .toList(),
      category: json['category'],
      importance: json['importance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconPath': iconPath,
      'steps': steps.map((step) => step.toJson()).toList(),
      'category': category,
      'importance': importance,
    };
  }

  static List<SurvivalGuide> getSampleGuides() {
    return [
      SurvivalGuide(
        id: '1',
        title: 'การเตรียมตัวก่อนน้ำท่วม',
        description: 'สิ่งที่ควรทำก่อนเกิดน้ำท่วมเพื่อลดความเสียหาย',
        iconPath: 'assets/icons/preparation.png',
        category: 'ก่อนน้ำท่วม',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'เตรียมถุงยังชีพ111',
            description: 'จัดเตรียมอาหารแห้ง น้ำดื่ม ยา และของใช้จำเป็น',
            imageUrl: 'assets/images/guide-1.jpg',
          ),
          SurvivalStep(
            title: 'ยกของมีค่าไว้ที่สูง',
            description: 'ยกของใช้สำคัญและเครื่องใช้ไฟฟ้าไว้บนที่สูง',
            imageUrl: 'assets/images/Flooding.jpg',
          ),
          SurvivalStep(
            title: 'ตรวจสอบทางออกฉุกเฉิน',
            description: 'กำหนดเส้นทางอพยพและจุดนัดพบ',
            imageUrl: 'assets/images/guide-2.jpg',
          ),
        ],
      ),
      SurvivalGuide(
        id: '2',
        title: 'การอยู่รอดระหว่างน้ำท่วม',
        description: 'วิธีรับมือในสถานการณ์น้ำท่วม',
        iconPath: 'assets/icons/survival.png',
        category: 'ระหว่างน้ำท่วม',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'ตัดไฟในบ้าน',
            description: 'สับเบรกเกอร์ไฟฟ้าหลักเพื่อป้องกันไฟฟ้าลัดวงจร',
            imageUrl: 'assets/images/breaker.jpg',
          ),
          SurvivalStep(
            title: 'ระวังสัตว์มีพิษ',
            description: 'ตรวจสอบรอบบ้านเพื่อป้องกันงูและสัตว์มีพิษอื่นๆ',
            imageUrl: 'assets/images/poisonous.jpg',
          ),
        ],
      ),
      SurvivalGuide(
        id: '3',
        title: 'การปฐมพยาบาลเบื้องต้น',
        description: 'รู้วิธีช่วยเหลือตนเองและผู้อื่นในยามฉุกเฉิน',
        iconPath: 'assets/icons/first_aid.png',
        category: 'สุขภาพ',
        importance: 4,
        steps: [
          SurvivalStep(
            title: 'รักษาแผลน้ำกัดเท้า',
            description: 'ทำความสะอาดด้วยน้ำสะอาดและทายาฆ่าเชื้อ',
            imageUrl: 'assets/images/foot.jpg',
          ),
          SurvivalStep(
            title: 'จัดการน้ำดื่ม',
            description: 'วิธีทำให้น้ำสะอาดเพื่อการบริโภค',
            imageUrl: 'assets/images/drink-water.jpg',
          ),
        ],
      ),
    ];
  }
}

class SurvivalStep {
  final String title;
  final String description;
  final String? imageUrl;

  SurvivalStep({
    required this.title,
    required this.description,
    this.imageUrl,
  });

  factory SurvivalStep.fromJson(Map<String, dynamic> json) {
    return SurvivalStep(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}