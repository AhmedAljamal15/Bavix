import 'package:flutter/material.dart';
import 'order_status_badge.dart';

/// Hero customer card — displays customer name and status with a prominent icon.
class HeroCustomerCard extends StatelessWidget {
  final bool isDark;
  final String customerName;
  final String status;
  final Color border;

  const HeroCustomerCard({
    super.key,
    required this.isDark,
    required this.customerName,
    required this.status,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? const Color(0xFF061A3A) : Colors.white,
        border: Border.all(
          color: isDark
              ? const Color(0xFF1D4ED8).withValues(alpha: .35)
              : Colors.black.withValues(alpha: .06),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: isDark ? .28 : .06),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1D4ED8).withValues(alpha: .22)
                  : const Color(0xFF2563EB).withValues(alpha: .10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.person_rounded,
              color: isDark ? Colors.white : const Color(0xFF2563EB),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                OrderStatusBadge(
                  label: status,
                  color: isDark
                      ? const Color(0xFF93C5FD)
                      : const Color(0xFF2563EB),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
