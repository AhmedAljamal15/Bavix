import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:erp_sales/features/sales_orders/data/repo/sales_orders_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_order_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_repository.dart';

import 'package:erp_sales/features/sales_orders/presentation/cubit/sales_orders_cubit.dart';
import 'package:erp_sales/features/sales_orders/presentation/cubit/sales_orders_state.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_order_details_screen.dart';

import '../widgets/orders_hero_header.dart';
import '../widgets/orders_stats_grid.dart';
import '../widgets/order_stat_card.dart';
import '../widgets/orders_search_box.dart';
import '../widgets/sales_order_card.dart';
import '../widgets/orders_empty_state.dart';
import '../widgets/orders_loading.dart';
import '../widgets/orders_error.dart';

class SalesOrdersScreen extends StatelessWidget {
  final SalesOrdersListRepository salesOrdersListRepository;
  final SalesOrderDetailsRepository salesOrderDetailsRepository;
  final DeliveryNoteRepository deliveryNoteRepository;
  final SalesInvoiceRepository salesInvoiceRepository;

  const SalesOrdersScreen({
    super.key,
    required this.salesOrdersListRepository,
    required this.salesOrderDetailsRepository,
    required this.deliveryNoteRepository,
    required this.salesInvoiceRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SalesOrdersCubit(salesOrdersListRepository)..getSalesOrders(),
      child: SalesOrdersView(
        salesOrderDetailsRepository: salesOrderDetailsRepository,
        deliveryNoteRepository: deliveryNoteRepository,
        salesInvoiceRepository: salesInvoiceRepository,
      ),
    );
  }
}

class SalesOrdersView extends StatefulWidget {
  final SalesOrderDetailsRepository salesOrderDetailsRepository;
  final DeliveryNoteRepository deliveryNoteRepository;
  final SalesInvoiceRepository salesInvoiceRepository;

  const SalesOrdersView({
    super.key,
    required this.salesOrderDetailsRepository,
    required this.deliveryNoteRepository,
    required this.salesInvoiceRepository,
  });

  @override
  State<SalesOrdersView> createState() => _SalesOrdersViewState();
}

class _SalesOrdersViewState extends State<SalesOrdersView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetails(BuildContext context, dynamic order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SalesOrderDetailsScreen(
          orderId: order.name,
          repository: widget.salesOrderDetailsRepository,
          deliveryNoteRepository: widget.deliveryNoteRepository,
          salesInvoiceRepository: widget.salesInvoiceRepository,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Draft':
        return const Color(0xFFF39C12);
      case 'Submitted':
        return const Color(0xFF42A5F5);
      case 'Completed':
        return const Color(0xFF2ECC71);
      case 'Cancelled':
        return const Color(0xFFE74C3C);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<SalesOrdersCubit, SalesOrdersState>(
        builder: (context, state) {
          if (state is SalesOrdersLoading) {
            return const OrdersLoading();
          }

          if (state is SalesOrdersError) {
            return OrdersError(
              message: state.message,
              onRetry: () =>
                  context.read<SalesOrdersCubit>().getSalesOrders(),
            );
          }

          if (state is SalesOrdersSuccess) {
            final orders = state.orders;

            final filteredOrders = orders.where((order) {
              final q = _query.toLowerCase().trim();
              if (q.isEmpty) return true;

              return order.name.toLowerCase().contains(q) ||
                  order.customer.toLowerCase().contains(q) ||
                  order.status.toLowerCase().contains(q) ||
                  (order.transactionDate ?? '').toLowerCase().contains(q) ||
                  (order.deliveryDate ?? '').toLowerCase().contains(q);
            }).toList();

            final draft = orders.where((o) => o.status == 'Draft').length;
            final submitted =
                orders.where((o) => o.status == 'Submitted').length;
            final completed =
                orders.where((o) => o.status == 'Completed').length;

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<SalesOrdersCubit>().getSalesOrders(),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  OrdersHeroHeader(
                    totalOrders: orders.length,
                    onBack: () => Navigator.pop(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                    child: Column(
                      children: [
                        OrdersStatsGrid(
                          children: [
                            OrderStatCard(
                              title: l10n.totalLabel,
                              value: orders.length.toString(),
                              icon: Icons.assignment_outlined,
                              color: const Color(0xFF42A5F5),
                            ),
                            OrderStatCard(
                              title: l10n.draft,
                              value: draft.toString(),
                              icon: Icons.edit_note_outlined,
                              color: const Color(0xFFF39C12),
                            ),
                            OrderStatCard(
                              title: l10n.submitted,
                              value: submitted.toString(),
                              icon: Icons.verified_outlined,
                              color: const Color(0xFF536DFE),
                            ),
                            OrderStatCard(
                              title: l10n.completed,
                              value: completed.toString(),
                              icon: Icons.check_circle_outline,
                              color: const Color(0xFF2ECC71),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        OrdersSearchBox(
                          hintText: l10n.searchOrders,
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() => _query = value);
                          },
                          onClear: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                        const SizedBox(height: 18),
                        if (orders.isEmpty)
                          OrdersEmptyState(
                            icon: Icons.assignment_outlined,
                            title: l10n.noSalesOrdersFound,
                            subtitle: l10n.salesOrdersWillAppearHere,
                          )
                        else if (filteredOrders.isEmpty)
                          OrdersEmptyState(
                            icon: Icons.search_off_rounded,
                            title: l10n.noMatchingOrders,
                            subtitle: l10n.trySearchingOrders,
                          )
                        else
                          Column(
                            children: filteredOrders.asMap().entries.map(
                              (entry) {
                                final index = entry.key;
                                final order = entry.value;
                                final color = _getStatusColor(order.status);

                                return SalesOrderCard(
                                  orderId: order.name,
                                  customer: order.customer,
                                  status: order.status,
                                  transactionDate:
                                      order.transactionDate ?? '',
                                  deliveryDate: order.deliveryDate ?? '',
                                  grandTotal: order.grandTotal.toString(),
                                  statusColor: color,
                                  onTap: () =>
                                      _openDetails(context, order),
                                )
                                    .animate()
                                    .fade(
                                      delay: (index * 45).ms,
                                      duration: 350.ms,
                                    )
                                    .slideY(begin: .08, duration: 350.ms);
                              },
                            ).toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}