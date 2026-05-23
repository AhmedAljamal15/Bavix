import 'package:flutter/material.dart';
import 'delivery_info_line.dart';
import 'delivery_icon_box.dart';
import 'delivery_badge.dart';

/// Card showing a single delivery note in the list.
class DeliveryNoteCard extends StatelessWidget {
  final String name;
  final String customer;
  final String postingDate;
  final String grandTotal;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  const DeliveryNoteCard({
    super.key,
    required this.name,
    required this.customer,
    required this.postingDate,
    required this.grandTotal,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF101A35) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF60A5FA).withValues(alpha: .22),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const DeliveryIconBox(
                  icon: Icons.local_shipping_outlined,
                  color: Color(0xFF60A5FA),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: dark ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                DeliveryBadge(label: status, color: statusColor),
              ],
            ),
            const SizedBox(height: 16),
            DeliveryInfoLine(
              icon: Icons.person_outline,
              text: customer,
            ),
            const SizedBox(height: 10),
            DeliveryInfoLine(
              icon: Icons.calendar_month_outlined,
              text: postingDate,
            ),
            const SizedBox(height: 10),
            DeliveryInfoLine(
              icon: Icons.payments_outlined,
              text: '$grandTotal EGP',
            ),
          ],
        ),
      ),
    );
  }
}
