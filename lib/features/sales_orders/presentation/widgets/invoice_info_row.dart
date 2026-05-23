import 'package:flutter/material.dart';

/// An info row showing an icon and text in the invoice cards.
class InvoiceInfoRow extends StatelessWidget {
  final IconData icon;
  final String value;

  const InvoiceInfoRow({super.key, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(icon, color: const Color(0xFF60A5FA), size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 15,
            ),
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: isDark ? Colors.white24 : Colors.black26,
        ),
      ],
    );
  }
}
