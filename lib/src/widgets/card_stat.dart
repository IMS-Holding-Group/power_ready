import 'package:flutter/material.dart';

class CardStat extends StatelessWidget {
  final String title;
  final double value;
  final String? subtitle;

  const CardStat({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    Color valueColor = _getColorForValue(value);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFB0B0B0),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
                const Text(
                  '%',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFB0B0B0),
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6A6A6A),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getColorForValue(double value) {
    if (value >= 80) {
      return const Color(0xFF00E676);
    } else if (value >= 60) {
      return const Color(0xFFFFC107);
    } else if (value >= 40) {
      return const Color(0xFFFF9800);
    } else {
      return const Color(0xFFFF5252);
    }
  }
}

