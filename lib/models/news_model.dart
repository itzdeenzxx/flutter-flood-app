
enum NewsUrgency { low, medium, high }

class NewsItem {
  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final String date;
  final NewsUrgency urgency;
  final String category;
  final String location;

  NewsItem({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.date,
    required this.urgency,
    required this.category,
    required this.location,
  });
}
