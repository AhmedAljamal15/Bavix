import 'package:flutter/material.dart';

/// Single selectable chip representing a search filter option.
class SearchFilterChipItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SearchFilterChipItem({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: selected,
        label: Text(label),
        onSelected: (_) => onTap(),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          color: selected
              ? Colors.white
              : isDark
                  ? Colors.white70
                  : const Color(0xFF111827),
        ),
        selectedColor: const Color(0xFF536DFE),
        backgroundColor: isDark ? const Color(0xFF101A35) : Colors.white,
        side: BorderSide(
          color: selected
              ? const Color(0xFF536DFE)
              : isDark
                  ? Colors.white.withValues(alpha: .10)
                  : Colors.black12,
        ),
      ),
    );
  }
}
