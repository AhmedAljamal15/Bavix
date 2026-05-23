import 'package:flutter/material.dart';
import 'item_icon_box.dart';

/// Pricing card showing the standard rate and UOM for an item.
class PricingCard extends StatelessWidget {
  final String standardRate;
  final String stockUom;

  const PricingCard({
    super.key,
    required this.standardRate,
    required this.stockUom,
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
      child: Row(
        children: [
          ItemIconBox(
            icon: Icons.payments_outlined,
            color: const Color(0xFF60A5FA),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  standardRate,
                  style: const TextStyle(
                    color: Color(0xFF60A5FA),
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Standard Rate / $stockUom',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
