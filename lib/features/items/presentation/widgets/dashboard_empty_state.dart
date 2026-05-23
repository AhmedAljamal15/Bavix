import 'package:flutter/material.dart';

/// Empty state widget used in dashboard sections when no data is found.
class DashboardEmptyState extends StatelessWidget {
  final String message;

  const DashboardEmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white60
                : Colors.black54,
          ),
        ),
      ),
    );
  }
}
