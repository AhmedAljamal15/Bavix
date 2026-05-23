import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';

/// An item card in the create sales invoice screen.
class InvoiceItemCard extends StatelessWidget {
  final String name;
  final String code;
  final String qty;
  final String uom;
  final String rate;
  final String amount;

  const InvoiceItemCard({
    super.key,
    required this.name,
    required this.code,
    required this.qty,
    required this.uom,
    required this.rate,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: dark ? const Color(0xFF101A35) : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(code, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: Text('${l10n.qtyLabel}: $qty $uom')),
              Expanded(child: Text('${l10n.rateLabel}: $rate')),
              Expanded(
                child: Text(
                  '${l10n.amountLabel}: $amount',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
