//home_screen.dart
import 'package:flutter/material.dart';
import 'package:flood_survival_app/widgets/dashboard_card.dart';
import 'package:flood_survival_app/widgets/guide_card.dart';
import 'package:flood_survival_app/widgets/bottom_navigation.dart';
import 'package:flood_survival_app/models/survival_guide.dart';
import 'package:flood_survival_app/config/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ข้อมูลจำลองสถานะการเตรียมพร้อม
  int preparednessPercentage = 0;
  final int waterLevel = 120; // ระดับน้ำในซม.
  final int waterLevelRisk = 2; // ระดับความเสี่ยง 1-3

  // ข้อมูลเช็คลิสต์
  List<Map<String, dynamic>> _checklistItems = [];
  bool _isLoading = true;

  // ข้อมูลตัวอย่างคำแนะนำด่วน
  final List<SurvivalGuide> quickGuides = SurvivalGuide.getSampleGuides();

  @override
  void initState() {
    super.initState();
    _loadChecklistFromFirestore();
  }

  // โหลดข้อมูลเช็คลิสต์จาก Firestore
  Future<void> _loadChecklistFromFirestore() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data.containsKey('checklist')) {
            setState(() {
              _checklistItems =
                  List<Map<String, dynamic>>.from(data['checklist']);
              _calculatePreparedness();
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading checklist: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // คำนวณเปอร์เซ็นต์ความพร้อม
  void _calculatePreparedness() {
    if (_checklistItems.isEmpty) {
      preparednessPercentage = 0;
      return;
    }

    int checkedItems =
        _checklistItems.where((item) => item['isChecked'] == true).length;
    preparednessPercentage =
        (checkedItems / _checklistItems.length * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รับมือน้ำท่วม'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // แถบย่อข้อมูลแจ้งเตือนระดับน้ำในพื้นที่
                    _buildWaterLevelAlert(),

                    const SizedBox(height: 16),

                    // บัตรแสดงข้อมูลการเตรียมพร้อม
                    DashboardCard(
                      title: 'การเตรียมพร้อม',
                      actionText: 'รายละเอียด →',
                      onActionTap: () {
                        Navigator.pushNamed(context, AppRoutes.survivalGuide)
                            .then((_) =>
                                _loadChecklistFromFirestore()); // Refresh data when returning from checklist
                      },
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(
                                  value: preparednessPercentage / 100,
                                  strokeWidth: 10,
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF4865E7),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$preparednessPercentage%',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4865E7),
                                    ),
                                  ),
                                  const Text(
                                    'พร้อมแล้ว',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildPreparednessItems(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ส่วนแสดงคำแนะนำวันนี้
                    _buildTodayGuides(),

                    const SizedBox(height: 24),

                    // ส่วนบัตรแสดงการตรวจสุขภาพ
                    _buildHealthCheck(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }

  // สร้างรายการเช็คลิสต์จาก Firestore
  List<Widget> _buildPreparednessItems() {
    List<Widget> items = [];

    // Show up to 5 items from the checklist
    final displayCount = _checklistItems.isEmpty
        ? 5
        : _checklistItems.length > 5
            ? 5
            : _checklistItems.length;

    if (_checklistItems.isEmpty) {
      // Default items when no data exists
      items = [
        _buildPreparednessItem('ถุงยังชีพ', false),
        _buildPreparednessItem('น้ำดื่มสะอาด', false),
        _buildPreparednessItem('ยกของขึ้นที่สูง', false),
        _buildPreparednessItem('แผนฉุกเฉิน', false),
        _buildPreparednessItem('ยาและเวชภัณฑ์', false),
      ];
    } else {
      // Show real checklist items
      for (var i = 0; i < displayCount; i++) {
        var item = _checklistItems[i];
        items.add(_buildPreparednessItem(
            item['name'] as String, item['isChecked'] as bool));
      }
    }

    return items;
  }

  Widget _buildWaterLevelAlert() {
    Color alertColor;
    String alertText;

    switch (waterLevelRisk) {
      case 1:
        alertColor = Colors.green;
        alertText = 'ระดับความเสี่ยงต่ำ';
        break;
      case 2:
        alertColor = Colors.orange;
        alertText = 'ระดับความเสี่ยงปานกลาง';
        break;
      case 3:
        alertColor = Colors.red;
        alertText = 'ระดับความเสี่ยงสูง';
        break;
      default:
        alertColor = Colors.green;
        alertText = 'ระดับความเสี่ยงต่ำ';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: alertColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: alertColor.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: alertColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alertText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: alertColor,
                  ),
                ),
                Text(
                  'ระดับน้ำในพื้นที่: $waterLevel ซม.',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // นำทางไปหน้าแสดงข้อมูลระดับน้ำโดยละเอียด
            },
            child: const Text('ดูเพิ่มเติม'),
          ),
        ],
      ),
    );
  }

  Widget _buildPreparednessItem(String label, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFF4865E7) : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: isCompleted
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isCompleted ? Colors.black : Colors.grey[600],
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayGuides() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'คำแนะนำวันนี้',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.survivalGuide);
              },
              child: const Text('ปรับแต่ง →'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: quickGuides.length,
            itemBuilder: (context, index) {
              final guide = quickGuides[index]; // <-- ใช้ตัวนี้เป็นค่า guide

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GuideCard(
                  guide: guide,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.survivalGuide,
                      arguments: guide.id,
                    );
                  },
                  cardColor: index == 0
                      ? const Color(0xFFFF6B6B)
                      : index == 1
                          ? const Color(0xFF4865E7)
                          : const Color(0xFF42B9A0),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildHealthCheck() {
    return DashboardCard(
      title: 'ตรวจสุขภาพ',
      actionText: 'วันนี้ →',
      onActionTap: () {
        Navigator.pushNamed(context, AppRoutes.healthCheck);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildHealthIcon(Icons.spa, 'สุขภาพ'),
          _buildHealthIcon(Icons.water_drop, 'น้ำดื่ม'),
          _buildHealthIcon(Icons.medical_services, 'ยา'),
          _buildHealthIcon(Icons.person, 'บุคคล'),
        ],
      ),
    );
  }

  Widget _buildHealthIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF4865E7).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: const Color(0xFF4865E7)),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.healthCheck);
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
