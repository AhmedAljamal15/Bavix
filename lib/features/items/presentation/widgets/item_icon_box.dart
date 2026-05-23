import 'package:flutter/material.dart';

/// An icon box used throughout item details — a square container with a tinted icon.
class ItemIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const ItemIconBox({super.key, required this.icon, required this.color});

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
