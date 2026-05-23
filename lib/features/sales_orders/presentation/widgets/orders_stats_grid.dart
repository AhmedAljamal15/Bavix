import 'package:flutter/material.dart';

/// A responsive stats grid for sales orders — 4 columns on wide, 2 on narrow.
class OrdersStatsGrid extends StatelessWidget {
  final List<Widget> children;

  const OrdersStatsGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 650 ? 4 : 2;
        const spacing = 10.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}
