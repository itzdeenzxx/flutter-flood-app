// lib/screens/news/news_screen.dart
import 'package:flutter/material.dart';
import 'package:flood_survival_app/services/news_service.dart';
import 'package:flood_survival_app/models/news_model.dart';
import 'package:flood_survival_app/config/routes.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'ข่าวล่าสุด',
    'ผลกระทบน้ำท่วม',
    'การช่วยเหลือ',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ข่าวสารสถานการณ์น้ำท่วม'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
          labelColor: isDarkMode ? Colors.white : theme.primaryColor,
          unselectedLabelColor: isDarkMode ? Colors.white70 : Colors.grey,
          indicatorColor: theme.primaryColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            _categories.map((category) => _buildNewsList(category)).toList(),
      ),
    );
  }

  Widget _buildNewsList(String category) {
    List<NewsItem> newsItems;

    if (category == 'ข่าวล่าสุด') {
      newsItems = NewsService.getNewsByCategory('ข่าวล่าสุด');
    } else if (category == 'ผลกระทบน้ำท่วม') {
      newsItems = NewsService.getNewsByCategory('ผลกระทบน้ำท่วม');
    } else if (category == 'การช่วยเหลือ') {
      newsItems = NewsService.getNewsByCategory('การช่วยเหลือ');
    } else {
      newsItems = NewsService.getNewsByCategory(category);
    }

    return ListView.builder(
      itemCount: newsItems.length,
      itemBuilder: (context, index) {
        final news = newsItems[index];
        return _buildNewsCard(news);
      },
    );
  }

  Widget _buildNewsCard(NewsItem news) {
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

    return GestureDetector(
      onTap: () {
        // กดแล้วไปหน้า NewsDetailScreen พร้อมส่ง newsId
        Navigator.pushNamed(
          context,
          AppRoutes.newsDetail,
          arguments: news.id,
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // รูปภาพข่าว
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    news.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.primaryColor.withOpacity(0.1),
                        child: const Center(
                          child: Icon(Icons.image, size: 48),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: urgencyColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getUrgencyText(news.urgency),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ข้อความข่าว
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        news.date,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.newsDetail,
                            arguments: news.id,
                          );
                        },
                        child: const Text('อ่านเพิ่มเติม'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
