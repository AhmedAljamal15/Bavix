import 'package:flutter/material.dart';

/// Shows a "Coming Soon" bottom sheet for un-implemented HR features.
void showHrComingSoonSheet(BuildContext context, String title) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 62,
                width: 62,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: const Color(0xFF60A5FA).withValues(alpha: .14),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF60A5FA),
                  size: 32,
                ),
              ),
              const SizedBox(height: 14),
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
                'This module is prepared for the next ERP version.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
