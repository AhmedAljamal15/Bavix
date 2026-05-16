import 'package:erp_sales/features/auth/presentation/widgets/stat_mini_card.dart';
import 'package:flutter/widgets.dart';

class StatsRow extends StatelessWidget {
  final int total;
  final int pending;
  final int approved;
  final int rejected;

  const StatsRow({super.key, 
    required this.total,
    required this.pending,
    required this.approved,
    required this.rejected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 8),
      child: Row(
        children: [
          Expanded(
            child: StatMiniCard(
              label: 'Total',
              value: total.toString(),
              color: const Color(0xFF60A5FA),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatMiniCard(
              label: 'Pending',
              value: pending.toString(),
              color: const Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatMiniCard(
              label: 'Approved',
              value: approved.toString(),
              color: const Color(0xFF22C55E),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatMiniCard(
              label: 'Rejected',
              value: rejected.toString(),
              color: const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }
}