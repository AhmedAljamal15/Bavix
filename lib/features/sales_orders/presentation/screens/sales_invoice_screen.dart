import 'package:erp_sales/features/sales_orders/data/models/create_sales_invoice_request.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoices_list_repository.dart';
import 'package:erp_sales/core/widgets/app_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import '../cubit/sales_invoice_cubit.dart';
import 'sales_invoice_view.dart';
import 'package:erp_sales/core/helpers/app_toast.dart';

class SalesInvoicesScreen extends StatelessWidget {
  final SalesInvoicesListRepository salesInvoicesListRepository;

  const SalesInvoicesScreen({
    super.key,
    required this.salesInvoicesListRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SalesInvoicesCubit(salesInvoicesListRepository)..getSalesInvoices(),
      child: SalesInvoicesView(),
    );
  }
}

class CreateSalesInvoiceScreen extends StatelessWidget {
  final dynamic order;
  final dynamic salesInvoiceRepository;

  const CreateSalesInvoiceScreen({
    super.key,
    required this.order,
    required this.salesInvoiceRepository,
  });

  Color _primaryColor() => const Color(0xFF8E44AD);

  int _itemsCount() {
    if (order.items == null) return 0;
    return (order.items as List).length;
  }

  Future<void> _createInvoice(BuildContext context) async {
    try {
      final request = CreateSalesInvoiceRequest(
        customer: order.customerName,
        postingDate: DateTime.now().toIso8601String().split('T').first,
        items: (order.items as List).map<CreateSalesInvoiceItemRequest>((item) {
          return CreateSalesInvoiceItemRequest(
            itemCode: item.itemCode,
            qty: (item.qty as num).toDouble(),
            salesOrder: order.name,
            soDetail: "",
            rate: (item.rate as num).toDouble(),
          );
        }).toList(),
      );

      await salesInvoiceRepository.createSalesInvoice(request);

      if (context.mounted) {
        AppToast.success('Invoice created successfully');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.error(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = _primaryColor();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: AppActionButton(
          onPressed: () => _createInvoice(context),
          icon: Icons.receipt_long_rounded,
          label: l10n.generateInvoice,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _InvoiceHeroHeader(
            orderId: order.name,
            onBack: () => Navigator.pop(context),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
            child: Column(
              children: [
                _StatsGrid(
                  children: [
                    _MiniStatCard(
                      title: l10n.customerLabel2,
                      value: order.customerName ?? '-',
                      icon: Icons.person_outline,
                      color: const Color(0xFF2ECC71),
                    ),
                    _MiniStatCard(
                      title: l10n.dateLabel,
                      value: order.transactionDate ?? '-',
                      icon: Icons.event_outlined,
                      color: const Color(0xFF42A5F5),
                    ),
                    _MiniStatCard(
                      title: l10n.itemsCountLabel,
                      value: _itemsCount().toString(),
                      icon: Icons.inventory_2_outlined,
                      color: const Color(0xFFF39C12),
                    ),
                    _MiniStatCard(
                      title: l10n.totalLabel,
                      value: '${order.grandTotal}',
                      icon: Icons.payments_outlined,
                      color: primary,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _SectionTitle(
                  icon: Icons.list_alt_outlined,
                  title: l10n.invoiceItemsSection,
                ),
                const SizedBox(height: 14),
                if (order.items != null && (order.items as List).isNotEmpty)
                  ...((order.items as List).map<Widget>((item) {
                    final qty = item.qty ?? 0;
                    final rate = item.rate ?? 0;
                    final amount = item.amount ?? 0;

                    return _InvoiceItemCard(
                      name: item.itemName ?? 'N/A',
                      code: item.itemCode ?? 'N/A',
                      qty: qty.toString(),
                      uom: item.uom ?? '',
                      rate: rate.toString(),
                      amount: amount.toString(),
                    );
                  }).toList())
                else
                  _EmptyBox(
                    icon: Icons.inventory_2_outlined,
                    title: l10n.noOrderItems,
                    subtitle: l10n.thisOrderHasNoItems,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceHeroHeader extends StatelessWidget {
  final String orderId;
  final VoidCallback onBack;

  const _InvoiceHeroHeader({required this.orderId, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 48, 18, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF020617),
                  const Color(0xFF25103D),
                  const Color(0xFF111827),
                ]
              : [const Color(0xFFF8F0FF), Colors.white],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
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
              const Expanded(
                child: Text(
                  'Create Invoice',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Sales Invoice Builder',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate invoice from order $orderId',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final List<Widget> children;

  const _StatsGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final width = (c.maxWidth - 10) / 2;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: children
              .map((e) => SizedBox(width: width, child: e))
              .toList(),
        );
      },
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: dark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(color: color.withValues(alpha: .18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _InvoiceItemCard extends StatelessWidget {
  final String name;
  final String code;
  final String qty;
  final String uom;
  final String rate;
  final String amount;

  const _InvoiceItemCard({
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

class _EmptyBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyBox({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Icon(icon, size: 54),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(subtitle),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
