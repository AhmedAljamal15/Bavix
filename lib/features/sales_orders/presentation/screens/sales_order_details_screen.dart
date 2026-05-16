import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/sales_orders/data/models/create_delivery_note_request.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_order_details_repository.dart';
import 'package:erp_sales/features/sales_orders/presentation/cubit/delivery_note_cubit.dart';
import 'package:erp_sales/features/sales_orders/presentation/cubit/delivery_note_state.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_invoice_screen.dart';
import 'package:erp_sales/core/helpers/app_toast.dart';

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
    if (isLoading) {
      return Scaffold(
        backgroundColor: bg,
        body: Center(child: CircularProgressIndicator(color: primary)),
      );
    }

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
          AppToast.success(
            AppLocalizations.of(context)!.deliveryNoteSubmittedSuccessfully,
          );
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
            _HeroCustomerCard(),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Order Details',
              icon: Icons.description_outlined,
              children: [
                _DetailRow(label: 'Date', value: order.transactionDate),
                _DetailRow(label: 'Delivery Date', value: order.deliveryDate),
                _DetailRow(label: 'Company', value: order.company),
                _DetailRow(label: 'Currency', value: order.currency),
              ],
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Order Summary',
              icon: Icons.analytics_outlined,
              children: [
                _DetailRow(label: 'Total Qty', value: '${order.totalQty}'),
                _DetailRow(label: 'Grand Total', value: '${order.grandTotal}'),
                _DetailRow(label: 'Billing Status', value: order.billingStatus),
                _DetailRow(
                  label: 'Delivery Status',
                  value: order.deliveryStatus,
                ),
              ],
            ),
            const SizedBox(height: 18),
            _ActionButton(
              label: AppLocalizations.of(context)!.createDeliveryNote,
              icon: Icons.local_shipping_rounded,
              color: const Color(0xFFF59E0B),
              onPressed: _createDeliveryNote,
            ),
            const SizedBox(height: 12),
            _ActionButton(
              label: AppLocalizations.of(context)!.viewSalesInvoice,
              icon: Icons.receipt_long_rounded,
              color: const Color(0xFF9B59B6),
              onPressed: _openSalesInvoice,
            ),
            if (createdDeliveryNoteName != null) ...[
              const SizedBox(height: 12),
              _ActionButton(
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
              return _OrderItemCard(item: item);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _HeroCustomerCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? const Color(0xFF061A3A) : Colors.white,
        border: Border.all(
          color: isDark
              ? const Color(0xFF1D4ED8).withValues(alpha: .35)
              : Colors.black.withValues(alpha: .06),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: isDark ? .28 : .06),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1D4ED8).withValues(alpha: .22)
                  : const Color(0xFF2563EB).withValues(alpha: .10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.person_rounded,
              color: isDark ? Colors.white : const Color(0xFF2563EB),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                _StatusBadge(
                  label: order.status,
                  color: isDark
                      ? const Color(0xFF93C5FD)
                      : const Color(0xFF2563EB),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _InfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: card,
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: isDark ? .16 : .05),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Draft':
        return Colors.orange;
      case 'Submitted':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).colorScheme.onSurface;
    final subText = Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: subText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  final dynamic item;

  const _OrderItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = Theme.of(context).colorScheme.surface;
    final text = Theme.of(context).colorScheme.onSurface;
    final subText = Theme.of(context).colorScheme.onSurfaceVariant;
    final border = Theme.of(context).dividerColor.withValues(alpha: .35);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: card,
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: isDark ? .14 : .04),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.primary.withValues(alpha: .12),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: text,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Code: ${item.itemCode}',
                        style: TextStyle(
                          color: subText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      'Qty: ${item.qty}',
                      style: TextStyle(
                        color: subText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _MiniBadge(label: item.uom),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.withValues(alpha: .18),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;

  const _MiniBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.withValues(alpha: .12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
