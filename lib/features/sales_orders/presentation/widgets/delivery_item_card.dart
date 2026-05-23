import 'package:flutter/material.dart';
import 'delivery_icon_box.dart';
import 'delivery_badge.dart';
import 'delivery_small_metric.dart';

/// Card for a single item in a delivery note detail view.
class DeliveryItemCard extends StatelessWidget {
  final String name;
  final String code;
  final String qty;
  final String uom;
  final String rate;
  final String amount;

  const DeliveryItemCard({
    super.key,
    required this.name,
    required this.code,
    required this.qty,
    required this.uom,
    required this.rate,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(
          color: const Color(0xFF60A5FA).withValues(alpha: .18),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const DeliveryIconBox(
                icon: Icons.inventory_2_outlined,
                color: Color(0xFF60A5FA),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      code,
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              DeliveryBadge(label: uom, color: const Color(0xFF60A5FA)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: DeliverySmallMetric(label: 'Qty', value: qty)),
              Expanded(child: DeliverySmallMetric(label: 'Rate', value: rate)),
              Expanded(
                child: DeliverySmallMetric(
                  label: 'Amount',
                  value: amount,
                  highlight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
