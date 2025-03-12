class EmergencyContact {
  final String id;
  final String name;
  final String phoneNumber;
  final String category;
  final String? address;
  final String? notes;
  final bool isFavorite;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.category,
    this.address,
    this.notes,
    this.isFavorite = false,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      category: json['category'],
      address: json['address'],
      notes: json['notes'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'category': category,
      'address': address,
      'notes': notes,
      'isFavorite': isFavorite,
    };
  }

  EmergencyContact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? category,
    String? address,
    String? notes,
    bool? isFavorite,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      category: category ?? this.category,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // For testing purposes only. In production, you'll fetch from Firestore.
  static List<EmergencyContact> getSampleContacts() {
    return [
      EmergencyContact(
        id: '1',
        name: 'สายด่วนน้ำท่วม',
        phoneNumber: '1784',
        category: 'หน่วยงานรัฐ',
        notes: 'แจ้งเหตุน้ำท่วมฉุกเฉิน 24 ชั่วโมง',
        isFavorite: true,
      ),
      EmergencyContact(
        id: '2',
        name: 'กรมป้องกันและบรรเทาสาธารณภัย',
        phoneNumber: '1784',
        category: 'หน่วยงานรัฐ',
        address: 'กระทรวงมหาดไทย ถนนอัษฎางค์ แขวงวัดราชบพิธ เขตพระนคร กรุงเทพฯ 10200',
      ),
      EmergencyContact(
        id: '3',
        name: 'ศูนย์เตือนภัยพิบัติแห่งชาติ',
        phoneNumber: '192',
        category: 'หน่วยงานรัฐ',
      ),
      EmergencyContact(
        id: '4',
        name: 'กรมอุตุนิยมวิทยา',
        phoneNumber: '1182',
        category: 'หน่วยงานรัฐ',
        notes: 'สอบถามข้อมูลสภาพอากาศและการพยากรณ์',
      ),
      EmergencyContact(
        id: '5',
        name: 'สายด่วนกรมชลประทาน',
        phoneNumber: '1460',
        category: 'หน่วยงานรัฐ',
        notes: 'สอบถามข้อมูลปริมาณน้ำและสถานการณ์น้ำทั่วประเทศ',
      ),
    ];
  }
}
