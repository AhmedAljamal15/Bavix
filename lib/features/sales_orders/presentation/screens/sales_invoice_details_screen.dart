import 'package:flutter/material.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_details_repository.dart';
import '../widgets/invoice_details_top_bar.dart';
import '../widgets/invoice_details_hero_card.dart';
import '../widgets/invoice_details_item_card.dart';

class SalesInvoiceDetailsScreen extends StatefulWidget {
  final String invoiceId;
  final SalesInvoiceDetailsRepository repository;

  const SalesInvoiceDetailsScreen({
    super.key,
    required this.invoiceId,
    required this.repository,
  });

  @override
  State<SalesInvoiceDetailsScreen> createState() =>
      _SalesInvoiceDetailsScreenState();
}

class _SalesInvoiceDetailsScreenState extends State<SalesInvoiceDetailsScreen> {
  dynamic invoice;
  bool isLoading = true;
  String? errorMessage;

  static const Color primary = Color(0xFF60A5FA);
  static const Color bgDark = Color(0xFF020617);

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final result = await widget.repository.getSalesInvoiceDetails(
        widget.invoiceId,
      );

      if (!mounted) return;

      setState(() {
        invoice = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return const Color(0xFF2ECC71);
      case 'unpaid':
        return const Color(0xFFF39C12);
      case 'overdue':
        return const Color(0xFFE74C3C);
      case 'draft':
        return const Color(0xFF42A5F5);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return const Scaffold(
        backgroundColor: bgDark,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: isDark
            ? bgDark
            : Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
          ),
        ),
      );
    }

    final statusColor = _statusColor(invoice.status);

    return Scaffold(
      backgroundColor: isDark
          ? bgDark
          : Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
          children: [
            InvoiceDetailsTopBar(
              title: invoice.name,
              onBack: () => Navigator.pop(context),
              onRefresh: load,
            ),
            const SizedBox(height: 22),
            InvoiceDetailsHeroCard(
              invoiceId: invoice.name,
              customerName: invoice.customerName,
              customer: invoice.customer,
              postingDate: invoice.postingDate,
              status: invoice.status,
              company: invoice.company,
              currency: invoice.currency,
              totalQty: '${invoice.totalQty}',
              grandTotal: '${invoice.grandTotal} ${invoice.currency}',
              statusColor: statusColor,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined, color: primary),
                const SizedBox(width: 10),
                Text(
                  'Items (${invoice.items.length})',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...invoice.items.map<Widget>(
              (item) => InvoiceDetailsItemCard(
                name: item.itemName,
                code: item.itemCode,
                qty: '${item.qty}',
                uom: item.uom,
                rate: '${item.rate}',
                amount: '${item.amount}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}


