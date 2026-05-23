import 'package:flutter/material.dart';

/// Small metric cell showing a label and value inside invoice item cards.
class InvoiceDetailsSmallMetric extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const InvoiceDetailsSmallMetric({
    super.key,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black45,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: highlight
                ? const Color(0xFF60A5FA)
                : isDark
                    ? Colors.white70
                    : Colors.black87,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
