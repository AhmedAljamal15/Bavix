import 'package:flutter/material.dart';

/// Hero intro card shown at the top of the create-customer form.
class CustomerHeroIntroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String selectedType;

  const CustomerHeroIntroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = selectedType == 'Company'
        ? const Color(0xFF9B59B6)
        : const Color(0xFF2ECC71);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF101A35), const Color(0xFF0B1228)]
              : [Colors.white, const Color(0xFFEFFFF7)],
        ),
        border: Border.all(color: typeColor.withValues(alpha: .18)),
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: typeColor.withValues(alpha: .14),
            ),
            child: Icon(
              selectedType == 'Company'
                  ? Icons.business_outlined
                  : Icons.person_outline_rounded,
              color: typeColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
