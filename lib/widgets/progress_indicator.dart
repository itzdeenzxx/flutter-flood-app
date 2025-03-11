import 'package:flutter/material.dart';

class CircularProgressCard extends StatelessWidget {
  final double progress;
  final String centerText;
  final String? subtitle;
  final Color progressColor;
  final Color backgroundColor;

  const CircularProgressCard({
    Key? key,
    required this.progress,
    required this.centerText,
    this.subtitle,
    this.progressColor = const Color(0xFF4865E7),
    this.backgroundColor = const Color(0xFFEEEEEE),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 10,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              centerText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: progressColor,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class LinearProgressCard extends StatelessWidget {
  final double progress;
  final String label;
  final String? valueText;
  final Color progressColor;
  final Color backgroundColor;

  const LinearProgressCard({
    Key? key,
    required this.progress,
    required this.label,
    this.valueText,
    this.progressColor = const Color(0xFF4865E7),
    this.backgroundColor = const Color(0xFFEEEEEE),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (valueText != null)
              Text(
                valueText!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}