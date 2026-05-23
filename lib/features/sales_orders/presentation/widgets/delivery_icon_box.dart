import 'package:flutter/material.dart';

/// Icon box for delivery notes feature — square icon container with tinted background.
class DeliveryIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const DeliveryIconBox({super.key, required this.icon, required this.color});

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
