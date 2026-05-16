import 'package:erp_sales/features/ai_assistant/data/models/ai_sales_order_draft.dart';
import 'package:flutter/material.dart';

class AiDraftPreviewCard extends StatelessWidget {
  final AiSalesOrderDraft draft;
  final VoidCallback onConfirm;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AiDraftPreviewCard({
    super.key,
    required this.draft,
    required this.onConfirm,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121826) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirm Sales Order',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Text('Customer: ${draft.customer}'),
          Text('Transaction Date: ${draft.transactionDate}'),
          Text('Delivery Date: ${draft.deliveryDate}'),
          const SizedBox(height: 12),
          ...draft.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '${item.itemCode} • Qty: ${item.qty} • Rate: ${item.rate} • Total: ${item.total}',
              ),
            );
          }),
          const Divider(height: 24),
          Text(
            'Grand Total: ${draft.total}',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: onConfirm,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Confirm Create'),
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text(actionLabel!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
