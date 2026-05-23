import 'package:flutter/material.dart';
import 'invoice_details_icon_box.dart';
import 'invoice_details_badge.dart';
import 'invoice_details_small_metric.dart';

/// Card showing item details in the sales invoice details screen.
class InvoiceDetailsItemCard extends StatelessWidget {
  final String name;
  final String code;
  final String qty;
  final String uom;
  final String rate;
  final String amount;

  const InvoiceDetailsItemCard({
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
        border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: .18)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const InvoiceDetailsIconBox(
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
                        color: isDark ? Colors.white : const Color(0xFF111827),
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
              InvoiceDetailsBadge(label: uom, color: const Color(0xFF60A5FA)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: InvoiceDetailsSmallMetric(label: 'Qty', value: qty),
              ),
              Expanded(
                child: InvoiceDetailsSmallMetric(label: 'Rate', value: rate),
              ),
              Expanded(
                child: InvoiceDetailsSmallMetric(
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
