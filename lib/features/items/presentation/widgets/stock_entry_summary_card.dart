import 'package:flutter/material.dart';
import 'package:erp_sales/features/items/data/models/item_model.dart';
import 'package:erp_sales/features/items/data/models/warehouse_model.dart';

/// Summary card showing a preview of the stock entry before submission.
class StockEntrySummaryCard extends StatelessWidget {
  final ItemModel? item;
  final WarehouseModel? warehouse;
  final String quantity;
  final String rate;

  const StockEntrySummaryCard({
    super.key,
    required this.item,
    required this.warehouse,
    required this.quantity,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final qty = double.tryParse(quantity.trim()) ?? 0;
    final basicRate = double.tryParse(rate.trim()) ?? 0;
    final amount = qty * basicRate;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF60A5FA).withValues(alpha: .16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stock Entry Summary',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 14),
          SummaryRow(label: 'Item', value: item?.itemName ?? '-'),
          SummaryRow(label: 'Warehouse', value: warehouse?.name ?? '-'),
          SummaryRow(label: 'Quantity', value: quantity),
          SummaryRow(label: 'Basic Rate', value: rate),
          const Divider(height: 22),
          SummaryRow(
            label: 'Estimated Amount',
            value: amount.toStringAsFixed(2),
            highlight: true,
          ),
        ],
      ),
    );
  }
}

/// A label-value row in the stock entry summary card.
class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: highlight
                    ? const Color(0xFF60A5FA)
                    : isDark
                    ? Colors.white
                    : const Color(0xFF111827),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
