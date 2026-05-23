import 'package:flutter/material.dart';
import 'invoice_details_icon_box.dart';
import 'invoice_details_badge.dart';
import 'invoice_details_info_grid.dart';
import 'invoice_details_info_cell.dart';

/// Top Hero card showing primary summary details for a sales invoice.
class InvoiceDetailsHeroCard extends StatelessWidget {
  final String invoiceId;
  final String customerName;
  final String customer;
  final String postingDate;
  final String status;
  final String company;
  final String currency;
  final String totalQty;
  final String grandTotal;
  final Color statusColor;

  const InvoiceDetailsHeroCard({
    super.key,
    required this.invoiceId,
    required this.customerName,
    required this.customer,
    required this.postingDate,
    required this.status,
    required this.company,
    required this.currency,
    required this.totalQty,
    required this.grandTotal,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF101A35), const Color(0xFF0B1228)]
              : [Colors.white, const Color(0xFFEFF6FF)],
        ),
        border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: .28)),
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
              const InvoiceDetailsIconBox(
                icon: Icons.receipt_long_outlined,
                color: Color(0xFF60A5FA),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Sales Invoice',
                  style: TextStyle(
                    color: Color(0xFF60A5FA),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              InvoiceDetailsBadge(label: status, color: statusColor),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            invoiceId,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 22),
          InvoiceDetailsInfoGrid(
            children: [
              InvoiceDetailsInfoCell(
                icon: Icons.person_outline,
                label: 'Customer',
                value: customerName.isEmpty ? customer : customerName,
              ),
              InvoiceDetailsInfoCell(
                icon: Icons.calendar_month_outlined,
                label: 'Posting Date',
                value: postingDate,
              ),
              InvoiceDetailsInfoCell(
                icon: Icons.flag_outlined,
                label: 'Status',
                value: status,
                valueColor: statusColor,
              ),
              InvoiceDetailsInfoCell(
                icon: Icons.business_outlined,
                label: 'Company',
                value: company,
              ),
              InvoiceDetailsInfoCell(
                icon: Icons.payments_outlined,
                label: 'Currency',
                value: currency,
              ),
              InvoiceDetailsInfoCell(
                icon: Icons.inventory_2_outlined,
                label: 'Total Qty',
                value: totalQty,
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'Grand Total',
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black54,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            grandTotal,
            style: const TextStyle(
              color: Color(0xFF60A5FA),
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
