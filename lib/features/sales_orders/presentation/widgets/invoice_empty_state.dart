import 'package:flutter/material.dart';

/// Empty state for the invoices list view.
class InvoiceEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const InvoiceEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Icon(
          Icons.receipt_long_outlined,
          size: 74,
          color: const Color(0xFF60A5FA).withValues(alpha: .45),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black54,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
