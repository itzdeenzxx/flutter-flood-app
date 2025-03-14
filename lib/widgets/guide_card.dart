import 'package:flutter/material.dart';
import 'package:flood_survival_app/models/survival_guide.dart';

class GuideCard extends StatelessWidget {
  final SurvivalGuide guide;
  final VoidCallback onTap;
  final Color cardColor;
  final Color textColor;

  const GuideCard({
    Key? key,
    required this.guide,
    required this.onTap,
    this.cardColor = const Color(0xFFF06292), // สีชมพูสำหรับความสำคัญสูง
    this.textColor = Colors.white,
  }) : super(key: key);

  factory GuideCard.fromImportance(
    SurvivalGuide guide, 
    VoidCallback onTap
  ) {
    // กำหนดสีตามระดับความสำคัญ
    Color cardColor;
    switch (guide.importance) {
      case 5:
        cardColor = const Color(0xFFF06292); // ชมพู - สำคัญมากที่สุด
        break;
      case 4:
        cardColor = const Color(0xFF5C6BC0); // น้ำเงิน - สำคัญมาก
        break;
      case 3:
        cardColor = const Color(0xFF26A69A); // เขียว - สำคัญปานกลาง
        break;
      default:
        cardColor = const Color(0xFF78909C); // เทา - สำคัญน้อย
    }

    return GuideCard(
      guide: guide,
      onTap: onTap,
      cardColor: cardColor,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              guide.title,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              guide.description,
              style: TextStyle(
                color: textColor.withOpacity(0.8),
                fontSize: 12,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (guide.steps.isNotEmpty)
              Text(
                '${guide.steps.length} ขั้นตอน',
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CategoryGuideCard extends StatelessWidget {
  final String category;
  final int itemCount;
  final VoidCallback onTap;
  final Color cardColor;
  final IconData icon;

  const CategoryGuideCard({
    Key? key,
    required this.category,
    required this.itemCount,
    required this.onTap,
    required this.cardColor,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor.withOpacity(0.1),
          border: Border.all(color: cardColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: cardColor,
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              category,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$itemCount รายการ',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
