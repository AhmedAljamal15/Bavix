import 'package:flutter/material.dart';
import 'invoice_status_badge.dart';
import 'invoice_info_row.dart';

/// Card displaying a single invoice in the invoices list.
class InvoiceCard extends StatelessWidget {
  final String invoiceId;
  final String customer;
  final String postingDate;
  final String total;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  const InvoiceCard({
    super.key,
    required this.invoiceId,
    required this.customer,
    required this.postingDate,
    required this.total,
    required this.status,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isDark ? const Color(0xFF101A35) : Colors.white,
            border: Border.all(
              color: const Color(0xFF3B82F6).withValues(alpha: .35),
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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF1E3A8A).withValues(alpha: .55),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      color: Color(0xFF60A5FA),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      invoiceId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  InvoiceStatusBadge(title: status, color: statusColor),
                ],
              ),
              const SizedBox(height: 18),
              InvoiceInfoRow(icon: Icons.person_outline, value: customer),
              const SizedBox(height: 10),
              InvoiceInfoRow(
                icon: Icons.calendar_month_outlined,
                value: postingDate,
              ),
              const SizedBox(height: 10),
              InvoiceInfoRow(icon: Icons.payments_outlined, value: total),
            ],
          ),
        ),
      ),
    );
  }
}
