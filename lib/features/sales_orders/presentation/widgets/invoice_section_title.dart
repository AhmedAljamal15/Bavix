import 'package:flutter/material.dart';

/// Section title row with icon + text — used in the invoice builder screen.
class InvoiceSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const InvoiceSectionTitle({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
