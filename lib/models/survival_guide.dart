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
            title: 'เตรียมถุงยังชีพ',
            description: 'จัดเตรียมอาหารแห้ง น้ำดื่ม ยา และของใช้จำเป็น',
            imageUrl: 'assets/images/guide-1.jpg',
          ),
          SurvivalStep(
            title: 'เก็บของมีค่าไว้ที่สูง',
            description: 'นำของใช้ที่สำคัญและเครื่องใช้ไฟฟ้าไว้บนที่สูง',
            imageUrl: 'assets/images/Flooding.jpg',
          ),
          SurvivalStep(
            title: 'ตรวจสอบทางออกฉุกเฉิน',
            description: 'กำหนดเส้นทางอพยพและจุดนัดพบ',
            imageUrl: 'assets/images/exits.jpg',
          ),
          SurvivalStep(
            title: 'ติดตามการเตือนภัยน้ำท่วม',
            description:
                'ติดตามการแจ้งเตือนผ่านระบบเสียงในพื้นที่หรือการแจ้งเตือนผ่านโทรศัพท์มือถือ',
            imageUrl: 'assets/images/Flood-warning.jpg',
          ),
          SurvivalStep(
            title: 'ทำความเข้าใจเกี่ยวกับการอพยพ',
            description:
                'ติดตามการแจ้งเตือนผ่านระบบเสียงในพื้นที่หรือการแจ้งเตือนผ่านโทรศัพท์มือถือ',
            imageUrl: 'assets/images/evacuation.jpg',
          ),
        ],
      ),

      SurvivalGuide(
        id: '2',
        title: 'ตรวจสอบที่พักอาศัย',
        description: 'ตรวจสอบที่พักอาศัยว่ามีความแข็งแรงหรือไม่',
        iconPath: 'assets/icons/preparation.png',
        category: 'ก่อนน้ำท่วม',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'ตรวจสอบสภาพบ้าน',
            description: 'เช่น หลังคา, ผนัง, ประตู',
            imageUrl: 'assets/images/home.png',
          ),
          SurvivalStep(
            title: 'ตรวจสอบระบบระบายน้ำ',
            description:
                'ตรวจสอบและทำความสะอาดท่อระบายน้ำเพื่อป้องกันการอุดตันที่อาจทำให้น้ำท่วมบ้านได้',
            imageUrl: 'assets/images/pipe.png',
          ),
        ],
      ),

      SurvivalGuide(
        id: '3',
        title: 'ป้องกันน้ำท่วมในบ้าน',
        description: 'ติดตั้งวัสดุที่ช่วยกันน้ำจากการไหลเข้ามาภายในบ้าน',
        iconPath: 'assets/icons/preparation.png',
        category: 'ก่อนน้ำท่วม',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'กระสอบทราย',
            description:
                'ใช้กระสอบทรายกั้นบริเวณทางเข้าบ้านเพื่อป้องกันน้ำท่วม',
            imageUrl: 'assets/images/sandbag.png',
          ),
          SurvivalStep(
            title: 'แผ่นกันน้ำ',
            description:
                'ใช้แผ่นพลาสติกหนาหรือวัสดุกันน้ำมาติดตั้งที่ประตูและหน้าต่าง',
            imageUrl: 'assets/images/L.png',
          ),
        ],
      ),
      SurvivalGuide(
        id: '4',
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
            imageUrl: 'assets/images/snake.jpg',
          ),
          SurvivalStep(
            title: 'ติดต่อขอความช่วยเหลือเมื่อจำเป็น',
            description:
                'ติดต่อหน่วยกู้ภัย หมายเลขฉุกเฉิน 1669 (สายด่วนกู้ชีพ) หรือ 191 (ตำรวจ)',
            imageUrl: 'assets/images/Rescue_unit.jpg',
          ),
        ],
      ),
      SurvivalGuide(
        id: '5',
        title: 'หลีกเลี่ยงน้ำที่ไหลเชี่ยวและน้ำลึก',
        description: 'ลดความเสี่ยงจากการถูกน้ำพัดพา',
        iconPath: 'assets/icons/survival.png',
        category: 'ระหว่างน้ำท่วม',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'หลีกเลี่ยงการเดินในน้ำที่ไหลเชี่ยว',
            description: '''
              1. หลีกเลี่ยงการเดินฝ่ากระแสน้ำ โดยเฉพาะในน้ำที่
                  ไหลเชี่ยวซึ่งอาจทำให้ถูกพัดพาไปได้
              2. คอยสังเกตสภาพน้ำ หากน้ำมีความลึกหรือไหลแรง 
                  ควรหาทางเลือกอื่นเพื่อหลีกเลี่ยง
              3. หากจำเป็นต้องข้ามน้ำ ให้ใช้เส้นทางที่มั่นคงและ
                  พยายามยึดสิ่งที่มั่นคงเพื่อไม่ให้ลื่นหรือถูกพัดพา
              ''',
            imageUrl: 'assets/images/water_flow.png',
          ),
          SurvivalStep(
            title: 'ระวังน้ำลึกที่มีความเสี่ยง',
            description: '''
              1. ตรวจสอบระดับน้ำก่อนข้ามหรือเดินผ่าน 
                  เพราะน้ำลึกอาจทำให้เกิดอันตราย
              2. หากน้ำสูงถึงเอวหรือสูงกว่านั้น ไม่ควรเดินฝ่าน้ำ 
                  เพราะอาจทำให้เสียการทรงตัว
              3. หากคุณไม่สามารถหลีกเลี่ยงการเดินผ่านน้ำได้ 
                  ให้เดินอย่างระมัดระวัง และหาทางออกที่ปลอดภัย
              ''',
            imageUrl: 'assets/images/walk.png',
          ),
        ],
      ),
      SurvivalGuide(
        id: '6',
        title: 'หลีกเลี่ยงการใช้ยานพาหนะในพื้นที่น้ำท่วม',
        description: 'เพื่อป้องกันอันตรายจากการไหลของน้ำและการจม',
        iconPath: 'assets/icons/survival.png',
        category: 'ระหว่างน้ำท่วม',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'หลีกเลี่ยงการขับรถในน้ำท่วม',
            description:
                'การขับรถผ่านน้ำท่วมอาจทำให้รถจม หรือทำให้เกิดอุบัติเหตุได้เนื่องจากกระแสน้ำที่แรง  หากน้ำท่วมสูงเกินกว่าระดับที่ปลอดภัย ควรหยุดรถและหาที่หลบภัยในพื้นที่สูงแทนที่จะขับต่อ',
            imageUrl: 'assets/images/car_flow.png',
          ),
          SurvivalStep(
            title: 'ใช้ยานพาหนะที่เหมาะสม',
            description:
                'หากจำเป็นต้องเดินทางในพื้นที่ที่น้ำท่วม ควรใช้ยานพาหนะที่สามารถผ่านน้ำท่วมได้ เช่น เรือหรือยานพาหนะที่มีล้อสูงการใช้รถยนต์ที่มีความสูงจากพื้นจะช่วยลดความเสี่ยงจากการจมน้ำ',
            imageUrl: 'assets/images/boat.png',
          ),
        ],
      ),
      SurvivalGuide(
        id: '7',
        title: 'การเริ่มฟื้นฟูพื้นที่',
        description:
            'ฟื้นฟูพื้นที่หลังน้ำท่วมเพื่อความปลอดภัยและการใช้ชีวิตที่ปกติ',
        iconPath: 'assets/icons/scorpion.png',
        category: 'หลังน้ำท่วม',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'ฟื้นฟูพื้นที่',
            description: '''
              วิธีฟื้นฟูพื้นที่หลังน้ำท่วม:
              1. ทำความสะอาดบ้าน ทันทีหลังจากน้ำลด 
                  เพื่อป้องกันเชื้อโรคและกลิ่นอับ  
              2. ฆ่าเชื้อในพื้นที่ที่เปียกชื้น 
              3. ตรวจสอบโครงสร้างบ้าน เช่น หลังคา, ผนัง 
                  และไฟฟ้า เพื่อความปลอดภัย  
              4. นำข้าวของที่เปียกไปตากแดด และทิ้งสิ่งของที่
                  ไม่สามารถใช้ได้ เช่น เตียงนอนที่เปียกน้ำ  

              ห้ามทำสิ่งต่อไปนี้:  
              - ห้ามใช้ไฟฟ้าในพื้นที่ที่มีน้ำขัง  
              - ห้ามเข้าไปในพื้นที่ที่มีโครงสร้างอาคารเสียหายร้ายแรง  
            ''',
            imageUrl: 'assets/images/cleaning.jpg',
          ),
          SurvivalStep(
            title: 'ฟื้นฟูต้นไม้และพืชผักสวนครัว',
            description: '''
              วิธีฟื้นฟูต้นไม้และพืชผักสวนครัวหลังน้ำท่วม:
              1. ตรวจสอบสภาพของต้นไม้  
              2. ตัดแต่งกิ่งและใบที่เสียหาย 
              3. ให้น้ำพืชอย่างพอเหมาะหลังจากน้ำท่วม 
              4. ใส่ปุ๋ยที่เหมาะสม เพื่อเสริมสร้างการเติบโต
                  และฟื้นฟูต้นไม้ให้แข็งแรง 

              ห้ามทำสิ่งต่อไปนี้:
              - ห้ามปลูกพืชในดินที่ยังมีน้ำท่วมขัง  
              - ห้ามใส่ปุ๋ยที่มีสารเคมีแรงในทันที เพราะอาจทำให้พืช
                 ได้รับอันตรายจากการรากพืชแช่น้ำ  
            ''',
            imageUrl: 'assets/images/trees.jpg',
          ),
        ],
      ),
      SurvivalGuide(
        id: '8',
        title: 'ตรวจสอบความปลอดภัย',
        description: 'ตรวจสอบความปลอดภัยในพื้นที่',
        iconPath: 'assets/icons/scorpion.png',
        category: 'หลังน้ำท่วม',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'ตรวจสอบอันตรายจากไฟฟ้า',
            description: '''
              วิธีตรวจสอบอันตรายจากไฟฟ้า:
              1. หากยังมีน้ำขังในบ้านหรือพื้นที่ใกล้เคียง 
                  ห้ามสัมผัสเครื่องใช้ไฟฟ้า 
              2. ตัดการจ่ายไฟ เพื่อป้องกันไฟฟ้าลัดวงจร  
              3. ตรวจสอบ ไฟฟ้ารั่ว โดยให้ช่างไฟฟ้า
                  มาตรวจสอบหากจำเป็น  
              4. หากพบสัญญาณไฟฟ้ารั่วหรือมีไฟฟ้าลัดวงจร
                  ให้รีบแจ้งเจ้าหน้าที่หรือช่างไฟฟ้าทันที  

              ห้ามทำสิ่งต่อไปนี้:
              - ห้ามสัมผัสอุปกรณ์ไฟฟ้าที่เปียก  
              - ห้ามเปิดหรือปิดเครื่องใช้ไฟฟ้าในขณะที่มือหรือพื้นเปียก  
            ''',
            imageUrl: 'assets/images/electric_current.jpg',
          ),
          SurvivalStep(
            title: 'ตรวจสอบอันตรายจากโครงสร้าง',
            description: '''
              วิธีตรวจสอบอันตรายจากโครงสร้าง:
              1. ตรวจสอบหลังคาว่ามีการรั่วซึมหรือไม่ 
                  หากพบรอยรั่วให้รีบซ่อมแซมทันที  
              2. ตรวจสอบผนังที่อาจมีรอยแตกร้าว
                  และดูว่าโครงสร้างเสี่ยงหรือไม่  
              3. หากพบบ้านหรืออาคารมีความเสียหายรุนแรง
                  ควรหลีกเลี่ยงการเข้าไปในพื้นที่นั้น 
              4. ตรวจสอบพื้นเพื่อดูว่าอาจมีการทรุดตัวหรือ
                  พื้นโครงสร้างได้รับความเสียหายหรือไม่  

              ห้ามทำสิ่งต่อไปนี้:
              - ห้ามเข้าไปในพื้นที่ที่มีความเสียหายรุนแรงจากน้ำท่วม  
              - ห้ามใช้สิ่งของหนักในการทดสอบโครงสร้าง 
                 เพราะอาจทำให้เกิดความเสียหายเพิ่ม  
            ''',
            imageUrl: 'assets/images/danger.jpg',
          )
        ],
      ),
      SurvivalGuide(
        id: '9',
        title: 'ประเมินความเสียหาย',
        description: 'ประเมินความเสียหายจากน้ำท่วม',
        iconPath: 'assets/icons/scorpion.png',
        category: 'หลังน้ำท่วม',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'ประเมินความเสียหาย',
            description: '''
              วิธีการประเมินความเสียหาย:
              1. ประเมินความเสียหายจากน้ำท่วม เช่น
                  ความเสียหายของทรัพย์สิน, บ้าน หรือพื้นที่
              2. ถ่ายภาพ หรือบันทึกข้อมูลเกี่ยวกับความเสียหายทั้งหมด 
                  เพื่อใช้เป็นหลักฐานในการแจ้งประกันภัย
              3. หากพบความเสียหายรุนแรง ควรแจ้งให้หน่วยงานที่
                  เกี่ยวข้องทราบ 
              4. ประเมินความเสี่ยงที่อาจเกิดขึ้นตามมา เช่น 
                  การเกิดโรคจากน้ำท่วม 

              ห้ามทำสิ่งต่อไปนี้:
              - ห้ามเข้าไปในพื้นที่ที่มีความเสี่ยงสูง เช่น 
                 อาคารที่ได้รับความเสียหายหนัก  
            ''',
            imageUrl: 'assets/images/house.jpg',
          ),
          SurvivalStep(
            title: 'ติดต่อหน่วยงานที่เกี่ยวข้อง',
            description: '''
            วิธีติดต่อหน่วยงานที่เกี่ยวข้อง:
              1. หากเกิดความเสียหายรุนแรง 
                  หรือจำเป็นต้องขอความช่วยเหลือ 
                  ควรติดต่อหน่วยงานที่เกี่ยวข้อง เช่น  
                - หน่วยกู้ภัย
                - หน่วยงานราชการท้องถิ่น  
                - บริษัทประกันภัย
              2. สำหรับกรณีฉุกเฉินที่เกี่ยวข้องกับชีวิต 
                  ติดต่อหมายเลขฉุกเฉิน เช่น 1669, 191
              3. เตรียมข้อมูลที่สำคัญ เช่น รายละเอียดที่อยู่, 
                  ลักษณะความเสียหาย, และข้อมูลการติดต่อ

              ห้ามทำสิ่งต่อไปนี้: 
              - ห้ามรอให้ความช่วยเหลือมาถึง หากมีความเสี่ยงที่
                 อาจจะทำให้สถานการณ์รุนแรงขึ้น  
            ''',
            imageUrl: 'assets/images/police.jpg',
          )
        ],
      ),
      SurvivalGuide(
        id: '10',
        title: 'การปฐมพยาบาลเบื้องต้น',
        description:
            'วิธีช่วยเหลือตนเองและผู้อื่นในเหตุการณ์ที่พบเห็นได้บ่อยครั้งในช่วงน้ำท่วม',
        iconPath: 'assets/icons/first_aid.png',
        category: 'สุขภาพ',
        importance: 4,
        steps: [
          SurvivalStep(
            title: 'รักษาแผลน้ำกัดเท้า',
            description: '''
              วิธีรักษาแผลน้ำกัดเท้า:
              1. ทำความสะอาดแผล ด้วยน้ำสะอาดและสบู่ 
              2. ทายาฆ่าเชื้อ หรือครีมป้องกันการติดเชื้อ 
              3. ปิดแผลด้วยผ้าก๊อซ หรือผ้าสะอาด 
              4. สังเกตอาการแผล หากแผลบวม แดง หรือมีหนอง
                  ควรพบแพทย์ทันที
              ''',
            imageUrl: 'assets/images/foot-wound.png',
          ),
          SurvivalStep(
            title: 'แผลเลือดออก',
            description: '''
              วิธีปฐมพยาบาลแผลเลือดออก:
              1. หยุดเลือด โดยการกดผ้าสะอาดหรือผ้าพันแผลที่แผล
              2. หากเลือดยังคงไหลไม่หยุด ให้ใช้ผ้าพันแผลผืนใหม่และ
                  กดทับซ้ำจนกว่าเลือดจะหยุดไหล
              3. รีบพาผู้บาดเจ็บไปโรงพยาบาล หรือหากมีการบาดเจ็บ
                  ที่รุนแรง ควรขอความช่วยเหลือจากหน่วยกู้ภัย

              ห้ามทำสิ่งต่อไปนี้: 
              - ห้ามใช้สิ่งของสกปรกหรือไม่สะอาดในการกดแผล  
              - ห้ามกดแผลอย่างรุนแรงเกินไป 
            ''',
            imageUrl: 'assets/images/cut-wound.png',
          ),
          SurvivalStep(
            title: 'เป็นลม หมดสติ',
            description: '''
              วิธีปฐมพยาบาลเมื่อเป็นลมหรือหมดสติ:
              1. วางผู้ป่วยในท่าหงาย 
              2. ตรวจสอบการหายใจ หากไม่มีการหายใจให้เริ่มทำ CPR 
              3. หากผู้ป่วยฟื้นคืนสติ ควรให้พักในท่านอนและดื่มน้ำบ่อย ๆ
              4. พาผู้ป่วยไปโรงพยาบาลหากยังไม่ฟื้นหรือมีอาการเสี่ยง

              ห้ามทำสิ่งต่อไปนี้:  
              - ห้ามให้ผู้ป่วยดื่มน้ำหรืออาหารทันทีหลังจากฟื้น  
              - ห้ามทำ CPR หากผู้ป่วยหายใจได้
            ''',
            imageUrl: 'assets/images/unconscious.png',
          ),
        ],
      ),
      SurvivalGuide(
        id: '11',
        title: 'จมน้ำ',
        description: 'วิธีช่วยเหลือผู้ประสบเหตุจมน้ำ',
        iconPath: 'assets/icons/first_aid.png',
        category: 'สุขภาพ',
        importance: 4,
        steps: [
          SurvivalStep(
            title: 'ดึงผู้จมน้ำออกจากน้ำ',
            description: '''
                  1. ดึงผู้จมน้ำออกจากน้ำอย่างระมัดระวัง
                  2. ช่วยให้ผู้จมน้ำขึ้นฝั่ง โดยวางให้เขานอนหงาย
                  3. ถ้ามีหลายคน ให้คนอื่นโทรหาหน่วยกู้ภัย
                      หรือแจ้งเจ้าหน้าที่ทันที
                  ''',
            imageUrl: 'assets/images/drowning.png',
          ),
          SurvivalStep(
            title: 'เริ่มทำ CPR',
            description: '''
                  1. ตรวจสอบการหายใจของผู้จมน้ำ หากไม่หายใจ
                      ให้เริ่มทำ CPR
                  2. วางมือสองข้างทับกันบนกลางหน้าอก และ
                      เริ่มกดลงไปในอัตรา 100-120 ครั้ง/นาที
                  3. ทำการกดอกประมาณ 2 นิ้วเพื่อ
                      ให้เกิดการไหลเวียนของเลือดไปสู่สมอง
                  4. หากผู้ป่วยยังไม่หายใจหรือหมดสติ ให้ดำเนินการ
                      CPR ต่อไปจนกว่าจะมีความช่วยเหลือ
                  ''',
            imageUrl: 'assets/images/CPR.png',
          ),
          SurvivalStep(
            title: 'ตรวจสอบการตอบสนอง',
            description: '''
                  1. สังเกตอาการ หากผู้จมน้ำฟื้นตัวและเริ่มหายใจ 
                     ให้วางเขานอนในท่าที่ปลอดภัย
                  2. หากไม่มีการหายใจ หรืออาการไม่ดีขึ้นให้ทำ 
                      CPR จนกว่าผู้ป่วยจะได้รับการช่วยเหลือ
                  3. รีบพาผู้ป่วยไปโรงพยาบาล หรือให้หน่วย
                      กู้ภัยเข้ามาช่วยทันที
                  ''',
            imageUrl: 'assets/images/hospital.png',
          ),
        ],
      ),
      SurvivalGuide(
        id: '12',
        title: 'ถูกสัตว์มีพิษทำร้าย',
        description: 'วิธีปฐมพยาบาลเบื้องต้นเมื่อถูกสัตว์มีพิษทำร้าย',
        iconPath: 'assets/icons/first_aid.png',
        category: 'สุขภาพ',
        importance: 4,
        steps: [
          SurvivalStep(
            title: 'ถูกงูกัด',
            description: '''
              วิธีปฐมพยาบาลเมื่อถูกงูกัด:
              1. สงบสติและนอนนิ่งๆ  
              2. ใช้ผ้าพันแผล หรือผ้าสะอาดพันเหนือรอยกัด  
              3. ห้ามขยับบริเวณที่ถูกกัด 
              4. รีบนำส่งโรงพยาบาล แจ้งชนิดของงู (ถ้าทราบ)
                  ให้แพทย์ทราบ  

              ห้ามทำสิ่งต่อไปนี้:
              - ห้ามใช้ปากดูดพิษ  
              - ห้ามใช้มีดกรีดแผล  
              - ห้ามใช้แอลกอฮอล์หรือยาสมุนไพรทาแผล    
              ''',
            imageUrl: 'assets/images/snake2.jpg',
          ),
          SurvivalStep(
            title: 'ถูกแมงป่องต่อย',
            description: '''
              วิธีปฐมพยาบาลเมื่อถูกแมงป่องต่อย:
              1. ล้างแผล ด้วยน้ำสะอาดและสบู่ทันที    
              2. ประคบเย็น  
              3. ทานยาแก้ปวด 
              4. หากมีอาการแพ้รุนแรง เช่น หายใจลำบาก หรือ หน้าบวม 
                  ให้รีบนำส่งโรงพยาบาลทันที  

              ห้ามทำสิ่งต่อไปนี้:  
              - ห้ามใช้มีดกรีดแผล  
              - ห้ามใช้แอลกอฮอล์หรือสารเคมีทาบริเวณแผล  
              - ห้ามใช้ปากดูดพิษ  
            ''',
            imageUrl: 'assets/images/scorpion.jpg',
          ),
          SurvivalStep(
            title: 'ถูกตะขาบกัด',
            description: '''
              วิธีปฐมพยาบาลเมื่อถูกตะขาบกัด:
              1. ล้างแผล ด้วยน้ำสะอาดและสบู่ทันที   
              2. ประคบร้อน 
              3. ยกบริเวณที่ถูกกัดให้สูงขึ้น เพื่อลดอาการบวม  
              4. ทานยาแก้ปวด และ ยาแก้แพ้ หากมีอาการคันหรือบวม  
              5. หากมีอาการแพ้รุนแรง เช่น หายใจลำบาก หรือ 
                  ผื่นขึ้นทั่วร่างกาย ให้รีบนำส่งโรงพยาบาลทันที  

              ห้ามทำสิ่งต่อไปนี้: 
              - ห้ามใช้มีดกรีดแผล  
              - ห้ามใช้แอลกอฮอล์ล้างแผล  
              - ห้ามใช้ปากดูดพิษ  
            ''',
            imageUrl: 'assets/images/centipede.jpg',
          ),
        ],
      ),

      //food and water

      SurvivalGuide(
        id: '13',
        title: 'อาหาร',
        description:
            'อาหารกระป๋องเก็บรักษาได้ยาวนาน เหมาะสำหรับใช้ในช่วงน้ำท่วม',
        iconPath: 'assets/icons/local_dining.png',
        category: 'อาหารและน้ำ',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'อาหารกระป๋อง',
            description:
                'อาหารกระป๋องที่ไม่มีน้ำ (เช่น ข้าวกระป๋อง, ผักและผลไม้กระป๋อง, เนื้อสัตว์กระป๋อง) เก็บรักษาง่ายและมีอายุการเก็บรักษานาน',
            imageUrl: 'assets/images/food.jpg',
          ),
          SurvivalStep(
            title: 'อาหารแห้ง',
            description:
                'ข้าวสาร, บะหมี่สำเร็จรูป, เส้นก๋วยเตี๋ยว, หรืออาหารแห้งที่ต้มได้ง่าย ๆ เช่น ซุปสำเร็จรูป',
            imageUrl: 'assets/images/noodles.jpg',
          ),
        ],
      ),

      SurvivalGuide(
        id: '14',
        title: 'น้ำดื่ม',
        description:
            'น้ำดื่มที่บรรจุในบรรจุภัณฑ์ที่เหมาะสม เก็บรักษาง่ายและไม่เสี่ยงต่อการปนเปื้อน',
        iconPath: 'assets/icons/local_dining.png',
        category: 'อาหารและน้ำ',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'น้ำดื่มสะอาด',
            description:
                'น้ำดื่มที่บรรจุในขวดพลาสติกหรือขวดแก้วที่สะอาดและปิดฝาสนิท ไม่ชำรุดหรือมีรอยรั่ว',
            imageUrl: 'assets/images/drinking_water.png',
          ),
        ],
      ),

      SurvivalGuide(
        id: '15',
        title: 'ประเมินสถานการณ์ก่อนเคลื่อนย้าย',
        description:
            'ประเมินความเสี่ยงและสถานการณ์อย่างรอบคอบก่อนตัดสินใจเคลื่อนย้าย',
        iconPath: 'assets/icons/run_circle.png',
        category: 'การเคลื่อนย้าย',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'ตรวจสอบระดับน้ำ และทิศทางการไหลของน้ำ',
            description: 'ตรวจสอบระดับน้ำในพื้นที่ที่อยู่ใกล้เคียง และติดตามทิศทางการไหลของน้ำเพื่อเตรียมความพร้อมในการเคลื่อนย้ายหรือหลีกเลี่ยงพื้นที่ที่มีความเสี่ยง',
            imageUrl: 'assets/images/water_levels.png',
          ),
          SurvivalStep(
            title: 'ฟังประกาศจากทางการหรือหน่วยงานช่วยเหลือ',
            description: 'ฟังการประกาศหรือคำแนะนำจากทางการหรือหน่วยงานช่วยเหลือ เช่น การอพยพหรือการแจ้งเตือนสถานการณ์ เพื่อปฏิบัติตามอย่างถูกต้อง',
            imageUrl: 'assets/images/deep_water.png',
          ),
          SurvivalStep(
            title:
                'หลีกเลี่ยงการเคลื่อนย้ายในช่วงกลางคืนหรือในพื้นที่ที่มีน้ำไหลแรง',
            description: 'หลีกเลี่ยงการเดินทางหรือเคลื่อนย้ายในเวลากลางคืนหรือในพื้นที่ที่มีน้ำไหลแรง เพื่อความปลอดภัยจากอุบัติเหตุหรืออันตราย',
            imageUrl: 'assets/images/night.png',
          ),
        ],
      ),

      SurvivalGuide(
        id: '16',
        title: 'พกสิ่งของจำเป็นติดตัว',
        description:
            'ตรวจสอบและเตรียมตัวให้พร้อมก่อนออกเดินทางเพื่อความปลอดภัย',
        iconPath: 'assets/icons/directions_walk.png',
        category: 'การเคลื่อนย้าย',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'น้ำดื่มสะอาดและอาหารแห้ง',
            description: 'จัดเตรียมน้ำดื่มสะอาดและอาหารแห้ง เก็บไว้ในที่ที่สามารถเข้าถึงได้ง่าย',
            imageUrl: 'assets/images/food_water.png',
          ),
          SurvivalStep(
            title: 'โทรศัพท์มือถือพร้อมแบตสำรอง',
            description: 'เตรียมโทรศัพท์มือถือและแบตสำรอง เพื่อให้สามารถติดต่อสื่อสารได้ในกรณีเกิดเหตุการณ์ฉุกเฉิน',
            imageUrl: 'assets/images/powerbank.png',
          ),
          SurvivalStep(
            title: 'ยาประจำตัว',
            description: 'จัดเตรียมยาประจำตัวหรือยาที่จำเป็นต่อการรักษาสุขภาพ เช่น ยาลดไข้ ยาลดความดัน หรือยาสำหรับโรคประจำตัว',
            imageUrl: 'assets/images/drug.png',
          ),
          SurvivalStep(
            title: 'เอกสารสำคัญ (ใส่ถุงกันน้ำ)',
            description: 'รวบรวมเอกสารสำคัญ เช่น บัตรประชาชน ทะเบียนบ้าน และเอกสารทางการเงิน แล้วใส่ในถุงกันน้ำเพื่อป้องกันความเสียหายจากน้ำท่วม',
            imageUrl: 'assets/images/document.png',
          ),
        ],
      ),

      SurvivalGuide(
        id: '17',
        title: 'ใช้เส้นทางปลอดภัย',
        description: 'ระมัดระวังและวางแผนให้ดีในการใช้เส้นทาง',
        iconPath: 'assets/icons/directions_walk.png',
        category: 'การเคลื่อนย้าย',
        importance: 5,
        steps: [
          SurvivalStep(
            title: 'ใช้เส้นทางที่มีการกำหนดหรือแนะนำจากเจ้าหน้าที่',
            description: 'เพื่อความปลอดภัยในการเคลื่อนย้ายในช่วงน้ำท่วม',
            imageUrl: 'assets/images/safe_routes.png',
          ),
          SurvivalStep(
            title: 'หลีกเลี่ยงถนนที่น้ำท่วมสูง หรือน้ำไหลแรง',
            description:
                'เพราะอาจเสี่ยงต่อการเกิดอุบัติเหตุและอันตรายจากสภาพแวดล้อมที่ไม่ปลอดภัย',
            imageUrl: 'assets/images/high_water.png',
          ),
          SurvivalStep(
            title: 'ระวังกระแสไฟฟ้ารั่ว',
            description:
                'หลีกเลี่ยงบริเวณที่มีสายไฟขาดหรือเสี่ยงต่อกระแสไฟฟ้ารั่ว และห้ามจับเสาไฟฟ้า หรืออุปกรณ์ไฟฟ้าที่แช่อยู่ในน้ำ',
            imageUrl: 'assets/images/electricity2.png',
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
