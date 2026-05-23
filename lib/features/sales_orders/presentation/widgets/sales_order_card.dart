import 'package:flutter/material.dart';
import 'order_info_box.dart';
import 'order_badge.dart';

/// Card displaying a single sales order in the list.
class SalesOrderCard extends StatelessWidget {
  final String orderId;
  final String customer;
  final String status;
  final String transactionDate;
  final String deliveryDate;
  final String grandTotal;
  final Color statusColor;
  final VoidCallback onTap;

  const SalesOrderCard({
    super.key,
    required this.orderId,
    required this.customer,
    required this.status,
    required this.transactionDate,
    required this.deliveryDate,
    required this.grandTotal,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 13),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isDark ? const Color(0xFF101A35) : Colors.white,
            border: Border.all(color: statusColor.withValues(alpha: .18)),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const Offset(0, 10),
                color: Colors.black.withValues(alpha: isDark ? .16 : .05),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: statusColor.withValues(alpha: .14),
                    ),
                    child: Icon(
                      Icons.assignment_outlined,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          customer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OrderBadge(label: status, color: statusColor),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OrderInfoBox(
                      label: 'Date',
                      value: transactionDate,
                      icon: Icons.event_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OrderInfoBox(
                      label: 'Delivery',
                      value: deliveryDate,
                      icon: Icons.local_shipping_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              OrderInfoBox(
                label: 'Grand Total',
                value: grandTotal,
                icon: Icons.payments_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
