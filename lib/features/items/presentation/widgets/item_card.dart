import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'item_badge.dart';
import 'info_box.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final String code;
  final String group;
  final String uom;
  final String rate;
  final bool isStockItem;
  final bool isSalesItem;
  final bool disabled;
  final VoidCallback onTap;

  const ItemCard({
    required this.name,
    required this.code,
    required this.group,
    required this.uom,
    required this.rate,
    required this.isStockItem,
    required this.isSalesItem,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final statusColor = disabled
        ? const Color(0xFFE74C3C)
        : const Color(0xFF2ECC71);

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
            border: Border.all(
              color: const Color(0xFF42A5F5).withValues(alpha: .16),
            ),
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
                      color: const Color(0xFF42A5F5).withValues(alpha: .14),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Color(0xFF42A5F5),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 2,
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
                          code,
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
                  ItemBadge(
                    label: disabled ? l10n.disabled : l10n.active,
                    color: statusColor,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: InfoBox(
                      label: l10n.groupLabel,
                      value: group,
                      icon: Icons.category_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InfoBox(
                      label: l10n.uom,
                      value: uom,
                      icon: Icons.straighten_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InfoBox(
                      label: l10n.rateLabel,
                      value: rate,
                      icon: Icons.sell_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InfoBox(
                      label: l10n.typeLabel,
                      value: isStockItem ? l10n.stockLabel : l10n.nonStock,
                      icon: Icons.warehouse_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ItemBadge(
                    label: isStockItem ? l10n.stockItem : l10n.notStock,
                    color: isStockItem ? const Color(0xFF42A5F5) : Colors.grey,
                  ),
                  ItemBadge(
                    label: isSalesItem ? l10n.salesItem : l10n.notSales,
                    color: isSalesItem ? const Color(0xFF2ECC71) : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
