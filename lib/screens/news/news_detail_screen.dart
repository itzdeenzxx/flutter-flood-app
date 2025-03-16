// lib/screens/news/news_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flood_survival_app/models/news_model.dart';
import 'package:flood_survival_app/services/news_service.dart';

class NewsDetailScreen extends StatelessWidget {
  final String newsId;
  const NewsDetailScreen({Key? key, required this.newsId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final news = NewsService.getNewsById(newsId);
    final theme = Theme.of(context);

    if (news == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('ไม่พบข่าวสาร')),
        body: const Center(child: Text('ไม่พบข้อมูลข่าวที่ต้องการ')),
      );
    }

    // กำหนดสี urgency
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดข่าวสาร'),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // รูปภาพ
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
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: urgencyColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getUrgencyText(news.urgency),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // เนื้อหา
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(news.date, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          news.location,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    news.description,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    news.content,
                    style: theme.textTheme.bodyMedium,
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
