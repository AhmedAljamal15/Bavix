import 'package:flutter/material.dart';

/// Responsive 2-column stats grid for the sales invoice screen.
class InvoiceStatsGrid extends StatelessWidget {
  final List<Widget> children;

  const InvoiceStatsGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final width = (c.maxWidth - 10) / 2;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: children
              .map((e) => SizedBox(width: width, child: e))
              .toList(),
        );
      },
    );
  }
}
