import 'package:flutter/material.dart';
import 'flag_row.dart';

/// Card showing item status flags: Stock Item, Sales Item, and Disabled status.
class StatusCard extends StatelessWidget {
  final bool isStockItem;
  final bool isSalesItem;
  final bool disabled;

  const StatusCard({
    super.key,
    required this.isStockItem,
    required this.isSalesItem,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFF60A5FA).withValues(alpha: .18),
        ),
      ),
      child: Column(
        children: [
          FlagRow(
            title: 'Stock Item',
            subtitle: isStockItem
                ? 'This item can be tracked in stock.'
                : 'Stock tracking is disabled.',
            active: isStockItem,
            icon: Icons.inventory_2_outlined,
          ),
          const SizedBox(height: 12),
          FlagRow(
            title: 'Sales Item',
            subtitle: isSalesItem
                ? 'This item can be used in sales.'
                : 'Sales usage is disabled.',
            active: isSalesItem,
            icon: Icons.sell_outlined,
          ),
          const SizedBox(height: 12),
          FlagRow(
            title: 'Item Status',
            subtitle: disabled
                ? 'This item is currently disabled.'
                : 'This item is active.',
            active: !disabled,
            icon: Icons.verified_outlined,
          ),
        ],
      ),
    );
  }
}
