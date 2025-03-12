import 'package:flutter/material.dart';
import 'package:flood_survival_app/models/survival_guide.dart';
import 'package:flood_survival_app/widgets/bottom_navigation.dart';

class SurvivalGuideScreen extends StatefulWidget {
  const SurvivalGuideScreen({Key? key}) : super(key: key);

  @override
  State<SurvivalGuideScreen> createState() => _SurvivalGuideScreenState();
}

class _SurvivalGuideScreenState extends State<SurvivalGuideScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<SurvivalGuide> guides = SurvivalGuide.getSampleGuides();
  String _selectedCategory = 'ทั้งหมด';
  
  final List<String> categories = [
    'ทั้งหมด',
    'ก่อนน้ำท่วม',
    'ระหว่างน้ำท่วม',
    'หลังน้ำท่วม',
    'สุขภาพ',
    'การเคลื่อนย้าย',
    'อาหารและน้ำ',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('คู่มือการเอาตัวรอด'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'คู่มือรับมือ'),
            Tab(text: 'เช็คลิสต์'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGuidesTab(),
          _buildChecklistTab(),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
    );
  }

  Widget _buildGuidesTab() {
    return Column(
      children: [
        _buildCategorySelector(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: guides.length,
            itemBuilder: (context, index) {
              final guide = guides[index];
              
              // กรองตามหมวดหมู่ที่เลือก
              if (_selectedCategory != 'ทั้งหมด' && guide.category != _selectedCategory) {
                return const SizedBox.shrink();
              }
              
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {
                    _showGuideDetails(guide);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(guide.category).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getCategoryIcon(guide.category),
                                color: _getCategoryColor(guide.category),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    guide.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    guide.category,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          guide.description,
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${guide.steps.length} ขั้นตอน',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: List.generate(
                                5,
                                (i) => Icon(
                                  Icons.star,
                                  size: 16,
                                  color: i < guide.importance
                                      ? const Color(0xFFFFC107)
                                      : Colors.grey[300],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == _selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: const Color(0xFF4865E7).withOpacity(0.1),
              checkmarkColor: const Color(0xFF4865E7),
              labelStyle: TextStyle(
                color: isSelected 
                    ? const Color(0xFF4865E7) 
                    : Colors.grey[800],
                fontWeight: isSelected 
                    ? FontWeight.bold 
                    : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChecklistTab() {
    // ตัวอย่างรายการเช็คลิสต์สิ่งของสำหรับเตรียมพร้อมรับมือน้ำท่วม
    final checklistItems = [
      {'name': 'ถุงยังชีพ', 'isChecked': true},
      {'name': 'น้ำดื่มสะอาด (3 ลิตรต่อคนต่อวัน)', 'isChecked': true},
      {'name': 'อาหารแห้งสำรอง (3-7 วัน)', 'isChecked': false},
      {'name': 'ยาและเวชภัณฑ์', 'isChecked': false},
      {'name': 'ไฟฉายและแบตเตอรี่สำรอง', 'isChecked': true},
      {'name': 'วิทยุแบบใช้ถ่าน', 'isChecked': false},
      {'name': 'แบตเตอรี่สำรอง/พาวเวอร์แบงค์', 'isChecked': true},
      {'name': 'เอกสารสำคัญใส่ซองกันน้ำ', 'isChecked': false},
      {'name': 'เงินสดสำรอง', 'isChecked': true},
      {'name': 'เสื้อผ้าและของใช้ส่วนตัว', 'isChecked': false},
      {'name': 'อุปกรณ์ทำความสะอาด', 'isChecked': false},
      {'name': 'ถุงขยะขนาดใหญ่', 'isChecked': false},
      {'name': 'นกหวีด (ส่งสัญญาณขอความช่วยเหลือ)', 'isChecked': false},
      {'name': 'เชือกและเทปกาว', 'isChecked': false},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'สิ่งของจำเป็นยามน้ำท่วม',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'รายการสิ่งของที่ควรเตรียมพร้อมไว้สำหรับรับมือกับสถานการณ์น้ำท่วม',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: checklistItems.where((item) => item['isChecked'] as bool).length / 
                         checklistItems.length,
                  backgroundColor: Colors.grey[200],
                  color: const Color(0xFF4865E7),
                ),
                const SizedBox(height: 8),
                Text(
                  'ความคืบหน้า: ${checklistItems.where((item) => item['isChecked'] as bool).length}/${checklistItems.length}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                const Divider(height: 32),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: checklistItems.length,
                  itemBuilder: (context, index) {
                    final item = checklistItems[index];
                    return CheckboxListTile(
                      title: Text(
                        item['name'] as String,
                        style: TextStyle(
                          decoration: item['isChecked'] as bool 
                              ? TextDecoration.lineThrough 
                              : null,
                          color: item['isChecked'] as bool 
                              ? Colors.grey[500] 
                              : Colors.black,
                        ),
                      ),
                      value: item['isChecked'] as bool,
                      activeColor: const Color(0xFF4865E7),
                      onChanged: (newValue) {
                        setState(() {
                          item['isChecked'] = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showGuideDetails(SurvivalGuide guide) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(guide.category).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getCategoryIcon(guide.category),
                        color: _getCategoryColor(guide.category),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            guide.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            guide.category,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    guide.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'ขั้นตอนการปฏิบัติ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(
                  guide.steps.length,
                  (index) => _buildStepItem(index + 1, guide.steps[index]),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // บันทึกคู่มือนี้ไว้ในรายการโปรด
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('เพิ่มในรายการโปรดแล้ว'),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4865E7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('บันทึกในรายการโปรด'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStepItem(int stepNumber, SurvivalStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF4865E7),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  step.description,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                if (step.imageUrl != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      step.imageUrl!,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 160,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'ก่อนน้ำท่วม':
        return const Color(0xFF42B9A0);
      case 'ระหว่างน้ำท่วม':
        return const Color(0xFF4865E7);
      case 'หลังน้ำท่วม':
        return const Color.fromARGB(255, 195, 101, 202);
      case 'สุขภาพ':
        return Colors.red;
      case 'การเคลื่อนย้าย':
        return const Color.fromARGB(255, 20, 149, 74);
      case 'อาหารและน้ำ':
        return const Color.fromARGB(255, 252, 126, 0);
      default:
        return Colors.indigo;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'ก่อนน้ำท่วม':
        return Icons.watch_later;
      case 'ระหว่างน้ำท่วม':
        return Icons.water;
      case 'หลังน้ำท่วม':
        return Icons.cleaning_services;
      case 'สุขภาพ':
        return Icons.favorite;
      case 'การเคลื่อนย้าย':
        return Icons.directions_walk;
        
      case 'อาหารและน้ำ':
        return Icons.local_dining;
      default:
        return Icons.info;
    }
  }
}