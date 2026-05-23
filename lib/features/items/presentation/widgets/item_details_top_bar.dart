import 'package:flutter/material.dart';

/// Top bar for the item details screen with back and refresh buttons.
class ItemDetailsTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  const ItemDetailsTopBar({
    super.key,
    required this.title,
    required this.onBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleIconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF111827),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        CircleIconButton(icon: Icons.refresh_rounded, onTap: onRefresh),
      ],
    );
  }
}

/// A circular icon button used in item-details top bar.
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF101A35) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: .08)
                : Colors.black12,
          ),
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white : const Color(0xFF111827),
          size: 20,
        ),
      ),
    );
  }
}
