import 'package:flutter/material.dart';

/// Shimmer-style loading placeholder for the orders list.
class OrdersLoading extends StatelessWidget {
  const OrdersLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF101A35) : Colors.white;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
      itemCount: 5,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 13),
        height: 150,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: .06)
                : Colors.black12,
          ),
        ),
      ),
    );
  }
}
