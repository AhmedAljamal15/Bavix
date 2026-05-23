import 'package:erp_sales/features/sales_orders/data/models/create_sales_invoice_request.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoices_list_repository.dart';
import 'package:erp_sales/core/widgets/app_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import '../cubit/sales_invoice_cubit.dart';
import 'sales_invoice_view.dart';
import 'package:erp_sales/core/helpers/app_toast.dart';
import '../widgets/invoice_hero_header.dart';
import '../widgets/invoice_stats_grid.dart';
import '../widgets/invoice_mini_stat_card.dart';
import '../widgets/invoice_section_title.dart';
import '../widgets/invoice_item_card.dart';
import '../widgets/invoice_empty_box.dart';

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
          InvoiceHeroHeader(
            orderId: order.name,
            onBack: () => Navigator.pop(context),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
            child: Column(
              children: [
                InvoiceStatsGrid(
                  children: [
                    InvoiceMiniStatCard(
                      title: l10n.customerLabel2,
                      value: order.customerName ?? '-',
                      icon: Icons.person_outline,
                      color: const Color(0xFF2ECC71),
                    ),
                    InvoiceMiniStatCard(
                      title: l10n.dateLabel,
                      value: order.transactionDate ?? '-',
                      icon: Icons.event_outlined,
                      color: const Color(0xFF42A5F5),
                    ),
                    InvoiceMiniStatCard(
                      title: l10n.itemsCountLabel,
                      value: _itemsCount().toString(),
                      icon: Icons.inventory_2_outlined,
                      color: const Color(0xFFF39C12),
                    ),
                    InvoiceMiniStatCard(
                      title: l10n.totalLabel,
                      value: '${order.grandTotal}',
                      icon: Icons.payments_outlined,
                      color: primary,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                InvoiceSectionTitle(
                  icon: Icons.list_alt_outlined,
                  title: l10n.invoiceItemsSection,
                ),
                const SizedBox(height: 14),
                if (order.items != null && (order.items as List).isNotEmpty)
                  ...((order.items as List).map<Widget>((item) {
                    final qty = item.qty ?? 0;
                    final rate = item.rate ?? 0;
                    final amount = item.amount ?? 0;

                    return InvoiceItemCard(
                      name: item.itemName ?? 'N/A',
                      code: item.itemCode ?? 'N/A',
                      qty: qty.toString(),
                      uom: item.uom ?? '',
                      rate: rate.toString(),
                      amount: amount.toString(),
                    );
                  }).toList())
                else
                  InvoiceEmptyBox(
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
