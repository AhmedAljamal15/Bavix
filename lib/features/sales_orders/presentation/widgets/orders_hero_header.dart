import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';

/// Hero header for the sales orders list screen.
class OrdersHeroHeader extends StatelessWidget {
  final int totalOrders;
  final VoidCallback onBack;

  const OrdersHeroHeader({
    super.key,
    required this.totalOrders,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 48, 18, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF020617),
                  const Color(0xFF3B1111),
                  const Color(0xFF111827),
                ]
              : [
                  const Color(0xFFFFF1F2),
                  Colors.white,
                ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 16),
            color: Colors.black.withValues(alpha: .12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              const Icon(
                Icons.assignment_outlined,
                color: Color(0xFFE74C3C),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.salesOrders,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            l10n.orderControlCenter,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.trackOrdersDescription,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFFE74C3C).withValues(alpha: .14),
            ),
            child: Text(
              l10n.ordersLoaded(totalOrders),
              style: const TextStyle(
                color: Color(0xFFE74C3C),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
