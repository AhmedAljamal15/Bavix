import 'package:flutter/material.dart';

/// Back button + centered title top bar used on the create-customer screen.
class CustomerTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const CustomerTopBar({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onBack,
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDark
                  ? Colors.white.withValues(alpha: .07)
                  : Colors.white,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: .08)
                    : Colors.black12,
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 44),
      ],
    );
  }
}
