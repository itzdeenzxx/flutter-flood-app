// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flood_survival_app/widgets/dashboard_card.dart';
import 'package:flood_survival_app/widgets/guide_card.dart';
import 'package:flood_survival_app/widgets/bottom_navigation.dart';
import 'package:flood_survival_app/models/survival_guide.dart';
import 'package:flood_survival_app/config/routes.dart';
import 'package:flood_survival_app/models/news_model.dart'; // เพิ่ม import
import 'package:flood_survival_app/services/news_service.dart'; // เพิ่ม import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flood_survival_app/screens/chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int preparednessPercentage = 0;
  final int waterLevel = 120; // ระดับน้ำในซม.
  final int waterLevelRisk = 2; // ระดับความเสี่ยง 1-3

  List<Map<String, dynamic>> _checklistItems = [];
  bool _isLoading = true;

  final List<SurvivalGuide> quickGuides = SurvivalGuide.getSampleGuides();
  late List<NewsItem> latestNews; // เพิ่มตัวแปรเก็บข่าวล่าสุด

  @override
  void initState() {
    super.initState();
    // ดึงข่าวล่าสุด 3 รายการ
    _loadChecklistFromFirestore();
    latestNews = NewsService.getNewsByCategory('ข่าวล่าสุด').take(3).toList();
  }

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
        title: const Text('WaveChill'),
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
                    // _buildWaterLevelAlert(),

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
                    _buildTodayGuides(),
                    const SizedBox(height: 24),
                    const SizedBox(height: 16),
                    _buildLatestNews(), // เพิ่มส่วนแสดงข่าวล่าสุด
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("เปิดแชทบอท");

          //จุดเรียกแชทบอท
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotScreen()),
          );
        },
        backgroundColor: const Color(0xFF1E88E5),
        tooltip: 'คุยกับแอลลี่',
        child: const Icon(Icons.smart_toy, color: Colors.white),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }

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

  // Widget _buildWaterLevelAlert() {
  //   Color alertColor;
  //   String alertText;

  //   switch (waterLevelRisk) {
  //     case 1:
  //       alertColor = Colors.green;
  //       alertText = 'ระดับความเสี่ยงต่ำ';
  //       break;
  //     case 2:
  //       alertColor = Colors.orange;
  //       alertText = 'ระดับความเสี่ยงปานกลาง';
  //       break;
  //     case 3:
  //       alertColor = Colors.red;
  //       alertText = 'ระดับความเสี่ยงสูง';
  //       break;
  //     default:
  //       alertColor = Colors.green;
  //       alertText = 'ระดับความเสี่ยงต่ำ';
  //   }

  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //     decoration: BoxDecoration(
  //       color: alertColor.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: alertColor.withOpacity(0.5)),
  // ),
  // child: Row(
  //   children: [
  //     Icon(Icons.warning_amber_rounded, color: alertColor),
  //     const SizedBox(width: 8),
  //     Expanded(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             alertText,
  //             style:
  //                 TextStyle(fontWeight: FontWeight.bold, color: alertColor),
  //           ),
  //           Text(
  //             'ระดับน้ำในพื้นที่: $waterLevel ซม.',
  //             style: TextStyle(color: Colors.grey[800]),
  //           ),
  //         ],
  //       ),
  //     ),
  //     TextButton(
  //       onPressed: () {}, // TODO: หน้าแสดงข้อมูลระดับน้ำ
  //       child: const Text('ดูเพิ่มเติม'),
  //     ),
  //   ],
  // ),
  //   );
  // }

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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.survivalGuide),
              child: const Text('ดูทั้งหมด →'),
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
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: AbsorbPointer(
                  absorbing: true, // กำหนดให้ widget นี้ไม่ตอบสนองต่อการกด
                  child: GuideCard.fromImportance(
                    quickGuides[index],
                    () => Navigator.pushNamed(
                      context,
                      AppRoutes.survivalGuide,
                      arguments: quickGuides[index].id,
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

  // เพิ่มฟังก์ชันสำหรับแสดงข่าวล่าสุด
  Widget _buildLatestNews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ข่าวสารสถานการณ์น้ำท่วม',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.news),
              child: const Text('ดูทั้งหมด →'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...latestNews.map((news) => _buildNewsItem(news)).toList(),
      ],
    );
  }

  // สร้าง Widget แสดงข่าวแต่ละรายการ
  Widget _buildNewsItem(NewsItem news) {
    final theme = Theme.of(context);
    Color urgencyColor;

    switch (news.urgency) {
      case NewsUrgency.high:
        urgencyColor = Colors.red;
        break;
      case NewsUrgency.medium:
        urgencyColor = Colors.orange;
        break;
      case NewsUrgency.low:
        urgencyColor = Colors.green;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          print(news.id);
          Navigator.pushNamed(
            context,
            AppRoutes.newsDetail,
            arguments: news.id,
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // รูปภาพข่าว
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(
                news.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: theme.primaryColor.withOpacity(0.1),
                    child: const Center(
                      child: Icon(Icons.image, size: 24),
                    ),
                  );
                },
              ),
            ),
            // เนื้อหาข่าว
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: urgencyColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getUrgencyText(news.urgency),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          news.date,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      news.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      news.description,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // เพิ่มฟังก์ชันแปลงความสำคัญของข่าว
  String _getUrgencyText(NewsUrgency urgency) {
    switch (urgency) {
      case NewsUrgency.high:
        return 'ด่วนที่สุด';
      case NewsUrgency.medium:
        return 'สำคัญ';
      case NewsUrgency.low:
        return 'ทั่วไป';
    }
  }
}
