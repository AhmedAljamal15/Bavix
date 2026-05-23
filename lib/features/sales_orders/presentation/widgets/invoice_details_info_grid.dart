import 'package:flutter/material.dart';

/// Wrap grid container for structuring cells in a 2-column layout.
class InvoiceDetailsInfoGrid extends StatelessWidget {
  final List<Widget> children;

  const InvoiceDetailsInfoGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final width = (constraints.maxWidth - spacing) / 2;

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
