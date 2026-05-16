import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const EmptyState({super.key, 
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const SizedBox(height: 120),
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF101A35) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFF60A5FA).withValues(alpha: .14),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.admin_panel_settings_outlined,
                size: 62,
                color: dark ? Colors.white38 : Colors.black26,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: dark ? Colors.white : Colors.black87,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: dark ? Colors.white54 : Colors.black45,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}