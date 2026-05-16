import 'package:flutter/material.dart';

class CustomersHeroHeader extends StatelessWidget {
  final int totalCustomers;
  final VoidCallback onBack;

  const CustomersHeroHeader({
    super.key,
    required this.totalCustomers,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 48, 18, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF020617),
                  const Color(0xFF052E2B),
                  const Color(0xFF064E3B),
                ]
              : [const Color(0xFFEFFFF7), Colors.white],
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
              const Icon(Icons.people_outline, color: Color(0xFF2ECC71)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Customers',
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
            'Client Command Center',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage customer profiles, groups, territories, and sales relationships.',
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
              color: const Color(0xFF2ECC71).withValues(alpha: .14),
            ),
            child: Text(
              '$totalCustomers customers loaded',
              style: const TextStyle(
                color: Color(0xFF2ECC71),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
