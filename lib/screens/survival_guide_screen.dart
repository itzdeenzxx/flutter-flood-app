// Import statements at the top of survival_guide_screen.dart
import 'package:flutter/material.dart';
import 'package:flood_survival_app/models/survival_guide.dart';
import 'package:flood_survival_app/widgets/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SurvivalGuideScreen extends StatefulWidget {
  const SurvivalGuideScreen({Key? key}) : super(key: key);

  @override
  State<SurvivalGuideScreen> createState() => _SurvivalGuideScreenState();
}

class _SurvivalGuideScreenState extends State<SurvivalGuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<SurvivalGuide> guides = SurvivalGuide.getSampleGuides();
  String _selectedCategory = 'ทั้งหมด';
  bool _isLoading = true;

  // Default checklist items
  List<Map<String, dynamic>> _checklistItems = [
    {'name': 'น้ำดื่มสะอาด (3 ลิตรต่อคนต่อวัน)', 'isChecked': false},
    {'name': 'อาหารสำเร็จรูป/อาหารกระป๋อง', 'isChecked': false},
    {'name': 'ไฟฉาย และ แบตเตอรี่สำรอง', 'isChecked': false},
    {'name': 'วิทยุแบบใช้ถ่าน', 'isChecked': false},
    {'name': 'ยาและเวชภัณฑ์', 'isChecked': false},
    {'name': 'เอกสารสำคัญในถุงกันน้ำ', 'isChecked': false},
    {'name': 'เสื้อผ้าที่จำเป็น', 'isChecked': false},
    {'name': 'ของใช้ส่วนตัว', 'isChecked': false},
    {'name': 'อุปกรณ์ทำความสะอาด', 'isChecked': false},
    {'name': 'เงินสดฉุกเฉิน', 'isChecked': false},
  ];

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
    _loadChecklistFromFirestore();
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
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildChecklistTab(),
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
              if (_selectedCategory != 'ทั้งหมด' &&
                  guide.category != _selectedCategory) {
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
                                color: _getCategoryColor(guide.category)
                                    .withOpacity(0.1),
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
                color: isSelected ? const Color(0xFF4865E7) : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChecklistTab() {
    final TextEditingController _newItemController = TextEditingController();

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
                  value: _checklistItems.isEmpty
                      ? 0
                      : _checklistItems
                              .where((item) => item['isChecked'] as bool)
                              .length /
                          _checklistItems.length,
                  backgroundColor: Colors.grey[200],
                  color: const Color(0xFF4865E7),
                ),
                const SizedBox(height: 8),
                Text(
                  'ความคืบหน้า: ${_checklistItems.where((item) => item['isChecked'] as bool).length}/${_checklistItems.length}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),

                // เพิ่มส่วนการป้อนรายการใหม่
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newItemController,
                          decoration: const InputDecoration(
                            hintText: 'เพิ่มรายการใหม่',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_newItemController.text.trim().isNotEmpty) {
                            setState(() {
                              Map<String, dynamic> newItem = {
                                'name': _newItemController.text.trim(),
                                'isChecked': false,
                              };
                              _checklistItems.add(newItem);
                              _newItemController.clear();

                              // Save the new item to Firestore
                              _saveChecklistToFirestore();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4865E7),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('เพิ่ม'),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 16),

                // รายการเช็คลิสต์
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _checklistItems.length,
                  itemBuilder: (context, index) {
                    final item = _checklistItems[index];
                    return Dismissible(
                      key: Key("${item['name']}_$index"),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          _checklistItems.removeAt(index);
                          // Update Firestore after removing item
                          _saveChecklistToFirestore();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ลบ "${item['name']}" แล้ว'),
                            action: SnackBarAction(
                              label: 'เลิกทำ',
                              onPressed: () {
                                setState(() {
                                  _checklistItems.insert(index, item);
                                  // Update Firestore after undoing delete
                                  _saveChecklistToFirestore();
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: CheckboxListTile(
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
                            // Save to Firestore when checkbox state changes
                            _saveChecklistToFirestore();
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
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

  // Method to save checklist to Firestore
  Future<void> _saveChecklistToFirestore() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({
          'checklist': _checklistItems,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // Calculate the preparedness percentage for the home screen
        int completedItems =
            _checklistItems.where((item) => item['isChecked'] as bool).length;
        int totalItems = _checklistItems.length;
        int preparednessPercentage =
            totalItems > 0 ? ((completedItems / totalItems) * 100).floor() : 0;

        // Update the user's preparedness percentage in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({
          'preparednessPercentage': preparednessPercentage,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error saving checklist: $e');
    }
  }

  // Method to load checklist from Firestore
  Future<void> _loadChecklistFromFirestore() async {
    try {
      setState(() {
        _isLoading = true;
      });

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('checklist')) {
            List<dynamic> checklistData = data['checklist'];
            setState(() {
              _checklistItems = checklistData
                  .map((item) =>
                      Map<String, dynamic>.from(item as Map<String, dynamic>))
                  .toList();
            });
          } else {
            // If user doesn't have a checklist yet, save the default one
            _saveChecklistToFirestore();
          }
        } else {
          // If user document doesn't exist, save the default checklist
          _saveChecklistToFirestore();
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading checklist: $e');
      setState(() {
        _isLoading = false;
      });
    }
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
                        color:
                            _getCategoryColor(guide.category).withOpacity(0.1),
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
