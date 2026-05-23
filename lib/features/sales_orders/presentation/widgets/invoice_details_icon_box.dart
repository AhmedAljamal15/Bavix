import 'package:flutter/material.dart';

/// A square tinted icon container used in invoice details screen.
class InvoiceDetailsIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const InvoiceDetailsIconBox({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: .14),
      ),
      child: Icon(icon, color: color),
    );
  }
}
