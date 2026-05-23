import 'package:flutter/material.dart';

/// Info card container — displays a section with title, icon and a list of children.
class OrderDetailsInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color primary;
  final Color card;
  final Color border;
  final bool isDark;
  final List<Widget> children;

  const OrderDetailsInfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.primary,
    required this.card,
    required this.border,
    required this.isDark,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: card,
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: isDark ? .16 : .05),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
