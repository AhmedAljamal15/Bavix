import 'package:flutter/material.dart';

/// Empty state box for when an order has no items in the invoice builder.
class InvoiceEmptyBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const InvoiceEmptyBox({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Icon(icon, size: 54),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(subtitle),
        ],
      ),
    );
  }
}
