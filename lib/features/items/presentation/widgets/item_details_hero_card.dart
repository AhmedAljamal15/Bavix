import 'package:flutter/material.dart';
import 'item_icon_box.dart';
import 'item_chip.dart';
import 'info_grid.dart';
import 'info_cell.dart';

/// Hero card displayed at the top of the item details screen.
class ItemDetailsHeroCard extends StatelessWidget {
  final String itemName;
  final String itemId;
  final String itemCode;
  final String itemGroup;
  final String standardRate;
  final String stockUom;
  final bool disabled;

  const ItemDetailsHeroCard({
    super.key,
    required this.itemName,
    required this.itemId,
    required this.itemCode,
    required this.itemGroup,
    required this.standardRate,
    required this.stockUom,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = disabled
        ? const Color(0xFFEF4444)
        : const Color(0xFF22C55E);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF101A35), const Color(0xFF0B1228)]
              : [Colors.white, const Color(0xFFEFF6FF)],
        ),
        border: Border.all(
          color: const Color(0xFF60A5FA).withValues(alpha: .24),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 12),
            color: Colors.black.withValues(alpha: isDark ? .18 : .06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ItemIconBox(
                icon: Icons.inventory_2_outlined,
                color: const Color(0xFF60A5FA),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Inventory Item',
                  style: TextStyle(
                    color: Color(0xFF60A5FA),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ItemChip(
                label: disabled ? 'Disabled' : 'Active',
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            itemName.isEmpty ? itemId : itemName,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            itemId,
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 22),
          InfoGrid(
            children: [
              InfoCell(
                icon: Icons.qr_code_rounded,
                label: 'Item Code',
                value: itemCode,
              ),
              InfoCell(
                icon: Icons.category_outlined,
                label: 'Group',
                value: itemGroup,
              ),
              InfoCell(
                icon: Icons.payments_outlined,
                label: 'Rate',
                value: standardRate,
                valueColor: const Color(0xFF60A5FA),
              ),
              InfoCell(
                icon: Icons.straighten_outlined,
                label: 'UOM',
                value: stockUom,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
