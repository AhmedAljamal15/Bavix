import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:erp_sales/features/sales_orders/data/models/create_delivery_note_request.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_order_details_repository.dart';
import 'package:erp_sales/features/sales_orders/presentation/cubit/delivery_note_cubit.dart';
import 'package:erp_sales/features/sales_orders/presentation/cubit/delivery_note_state.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_invoice_screen.dart';
import 'package:erp_sales/core/helpers/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/detail_row.dart';
import '../widgets/order_action_button.dart';
import '../widgets/order_item_card.dart';
import '../widgets/hero_customer_card.dart';
import '../widgets/order_details_info_card.dart';

class SalesOrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final SalesOrderDetailsRepository repository;
  final DeliveryNoteRepository deliveryNoteRepository;
  final SalesInvoiceRepository salesInvoiceRepository;

  const SalesOrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.repository,
    required this.deliveryNoteRepository,
    required this.salesInvoiceRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeliveryNoteCubit(deliveryNoteRepository),
      child: SalesOrderDetailsView(
        orderId: orderId,
        repository: repository,
        salesInvoiceRepository: salesInvoiceRepository,
      ),
    );
  }
}

class SalesOrderDetailsView extends StatefulWidget {
  final String orderId;
  final SalesOrderDetailsRepository repository;
  final SalesInvoiceRepository salesInvoiceRepository;

  const SalesOrderDetailsView({
    super.key,
    required this.orderId,
    required this.repository,
    required this.salesInvoiceRepository,
  });

  @override
  State<SalesOrderDetailsView> createState() => _SalesOrderDetailsViewState();
}

class _SalesOrderDetailsViewState extends State<SalesOrderDetailsView> {
  dynamic order;
  bool isLoading = true;
  String? createdDeliveryNoteName;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final result = await widget.repository.getOrderDetails(widget.orderId);

    if (!mounted) return;

    setState(() {
      order = result;
      isLoading = false;
    });
  }

  Color get primary => Theme.of(context).colorScheme.primary;
  Color get bg => Theme.of(context).scaffoldBackgroundColor;
  Color get card => Theme.of(context).colorScheme.surface;
  Color get text => Theme.of(context).colorScheme.onSurface;
  Color get subText => Theme.of(context).colorScheme.onSurfaceVariant;
  Color get border => Theme.of(context).dividerColor.withValues(alpha: .35);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return Scaffold(
        backgroundColor: bg,
        body: Center(child: CircularProgressIndicator(color: primary)),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<DeliveryNoteCubit, DeliveryNoteState>(
      listener: (context, state) {
        if (state is DeliveryNoteSuccess) {
          setState(() {
            createdDeliveryNoteName = state.deliveryNoteName;
          });

          AppToast.success(
            'Delivery Note draft created: ${state.deliveryNoteName}',
          );
        }

        if (state is DeliveryNoteSubmitSuccess) {
          AppToast.success(l10n.deliveryNoteSubmittedSuccessfully);
        }

        if (state is DeliveryNoteError) {
          AppToast.error(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          centerTitle: true,
          title: Text(
            order.name,
            style: TextStyle(
              color: text,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          iconTheme: IconThemeData(color: text),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            HeroCustomerCard(
              isDark: isDark,
              customerName: order.customerName,
              status: order.status,
              border: border,
            ),
            const SizedBox(height: 16),
            OrderDetailsInfoCard(
              title: 'Order Details',
              icon: Icons.description_outlined,
              primary: primary,
              card: card,
              border: border,
              isDark: isDark,
              children: [
                DetailRow(label: 'Date', value: order.transactionDate),
                DetailRow(
                  label: 'Delivery Date',
                  value: order.deliveryDate,
                ),
                DetailRow(label: 'Company', value: order.company),
                DetailRow(label: 'Currency', value: order.currency),
              ],
            ),
            const SizedBox(height: 16),
            OrderDetailsInfoCard(
              title: 'Order Summary',
              icon: Icons.analytics_outlined,
              primary: primary,
              card: card,
              border: border,
              isDark: isDark,
              children: [
                DetailRow(label: 'Total Qty', value: '${order.totalQty}'),
                DetailRow(label: 'Grand Total', value: '${order.grandTotal}'),
                DetailRow(
                  label: 'Billing Status',
                  value: order.billingStatus,
                ),
                DetailRow(
                  label: 'Delivery Status',
                  value: order.deliveryStatus,
                ),
              ],
            ),
            const SizedBox(height: 18),
            OrderActionButton(
              label: l10n.createDeliveryNote,
              icon: Icons.local_shipping_rounded,
              color: const Color(0xFFF59E0B),
              onPressed: _createDeliveryNote,
            ),
            const SizedBox(height: 12),
            OrderActionButton(
              label: l10n.viewSalesInvoice,
              icon: Icons.receipt_long_rounded,
              color: const Color(0xFF9B59B6),
              onPressed: _openSalesInvoice,
            ),
            if (createdDeliveryNoteName != null) ...[
              const SizedBox(height: 12),
              OrderActionButton(
                label: 'Submit: $createdDeliveryNoteName',
                icon: Icons.check_circle_rounded,
                color: const Color(0xFF16A34A),
                onPressed: () {
                  context.read<DeliveryNoteCubit>().submitDeliveryNote(
                    createdDeliveryNoteName!,
                  );
                },
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Order Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: text,
              ),
            ),
            const SizedBox(height: 12),
            ...order.items.map<Widget>((item) {
              return OrderItemCard(item: item);
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _createDeliveryNote() {
    final request = CreateDeliveryNoteRequest(
      customer: order.customerName,
      postingDate: order.transactionDate,
      items: order.items.map<CreateDeliveryNoteItemRequest>((item) {
        return CreateDeliveryNoteItemRequest(
          itemCode: item.itemCode,
          qty: item.qty,
          warehouse: item.warehouse,
          againstSalesOrder: order.name,
          againstSalesOrderItem: item.salesOrderItemId,
        );
      }).toList(),
    );

    context.read<DeliveryNoteCubit>().createDeliveryNote(request);
  }

  void _openSalesInvoice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateSalesInvoiceScreen(
          order: order,
          salesInvoiceRepository: widget.salesInvoiceRepository,
        ),
      ),
    );
  }
}

