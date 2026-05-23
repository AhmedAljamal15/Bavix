import 'package:flutter/material.dart';
import 'item_icon_box.dart';
import 'item_chip.dart';

/// A flag row showing an icon, title/subtitle and an active/inactive chip.
class FlagRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;
  final IconData icon;

  const FlagRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.active,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = active ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF020617).withValues(alpha: .65)
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: .18)),
      ),
      child: Row(
        children: [
          ItemIconBox(icon: icon, color: color),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ItemChip(label: active ? 'Yes' : 'No', color: color),
        ],
      ),
    );
  }
}
