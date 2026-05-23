import 'package:flutter/material.dart';

/// Premium empty state for the sales orders list screen.
class OrdersEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const OrdersEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 74,
          color: const Color(0xFFE74C3C).withValues(alpha: .4),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white60 : Colors.black54,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
