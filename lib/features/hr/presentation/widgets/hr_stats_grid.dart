import 'package:flutter/material.dart';

/// A 2-column responsive wrap grid used for both stat cards and action cards.
class HrStatsGrid extends StatelessWidget {
  final List<Widget> children;

  const HrStatsGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        const spacing = 11.0;
        final width = (c.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((e) => SizedBox(width: width, child: e))
              .toList(),
        );
      },
    );
  }
}
