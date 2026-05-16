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
            return const _OrdersLoading();
          }

          if (state is SalesOrdersError) {
            return _OrdersError(
              message: state.message,
              onRetry: () => context.read<SalesOrdersCubit>().getSalesOrders(),
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
              onRefresh: () => context.read<SalesOrdersCubit>().getSalesOrders(),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _OrdersHeroHeader(
                    totalOrders: orders.length,
                    onBack: () => Navigator.pop(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                    child: Column(
                      children: [
                        _StatsGrid(
                          children: [
                            _OrderStatCard(
                              title: l10n.totalLabel,
                              value: orders.length.toString(),
                              icon: Icons.assignment_outlined,
                              color: const Color(0xFF42A5F5),
                            ),
                            _OrderStatCard(
                              title: l10n.draft,
                              value: draft.toString(),
                              icon: Icons.edit_note_outlined,
                              color: const Color(0xFFF39C12),
                            ),
                            _OrderStatCard(
                              title: l10n.submitted,
                              value: submitted.toString(),
                              icon: Icons.verified_outlined,
                              color: const Color(0xFF536DFE),
                            ),
                            _OrderStatCard(
                              title: l10n.completed,
                              value: completed.toString(),
                              icon: Icons.check_circle_outline,
                              color: const Color(0xFF2ECC71),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _SearchBox(
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
                          _PremiumEmptyState(
                            icon: Icons.assignment_outlined,
                            title: l10n.noSalesOrdersFound,
                            message: l10n.salesOrdersWillAppearHere,
                          )
                        else if (filteredOrders.isEmpty)
                          _PremiumEmptyState(
                            icon: Icons.search_off_rounded,
                            title: l10n.noMatchingOrders,
                            message: l10n.trySearchingOrders,
                          )
                        else
                          Column(
                            children: filteredOrders.asMap().entries.map(
                              (entry) {
                                final index = entry.key;
                                final order = entry.value;
                                final color = _getStatusColor(order.status);

                                return _SalesOrderCard(
                                  orderId: order.name,
                                  customer: order.customer,
                                  status: order.status,
                                  transactionDate:
                                      order.transactionDate ?? '',
                                  deliveryDate: order.deliveryDate ?? '',
                                  grandTotal: order.grandTotal.toString(),
                                  statusColor: color,
                                  onTap: () => _openDetails(context, order),
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

class _OrdersHeroHeader extends StatelessWidget {
  final int totalOrders;
  final VoidCallback onBack;

  const _OrdersHeroHeader({
    required this.totalOrders,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 48, 18, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF020617),
                  const Color(0xFF3B1111),
                  const Color(0xFF111827),
                ]
              : [
                  const Color(0xFFFFF1F2),
                  Colors.white,
                ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 16),
            color: Colors.black.withValues(alpha: .12),
          ),
        ],
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
              const Icon(
                Icons.assignment_outlined,
                color: Color(0xFFE74C3C),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.salesOrders,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            l10n.orderControlCenter,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.trackOrdersDescription,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFFE74C3C).withValues(alpha: .14),
            ),
            child: Text(
              l10n.ordersLoaded(totalOrders),
              style: const TextStyle(
                color: Color(0xFFE74C3C),
                fontWeight: FontWeight.w800,
              ),
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
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 650 ? 4 : 2;
        const spacing = 10.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}

class _OrderStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _OrderStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 118,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(color: color.withValues(alpha: .18)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: isDark ? .16 : .05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String hintText;

  const _SearchBox({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: .09) : Colors.black12,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: isDark ? .14 : .05),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _SalesOrderCard extends StatelessWidget {
  final String orderId;
  final String customer;
  final String status;
  final String transactionDate;
  final String deliveryDate;
  final String grandTotal;
  final Color statusColor;
  final VoidCallback onTap;

  const _SalesOrderCard({
    required this.orderId,
    required this.customer,
    required this.status,
    required this.transactionDate,
    required this.deliveryDate,
    required this.grandTotal,
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
          margin: const EdgeInsets.only(bottom: 13),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isDark ? const Color(0xFF101A35) : Colors.white,
            border: Border.all(color: statusColor.withValues(alpha: .18)),
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
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: statusColor.withValues(alpha: .14),
                    ),
                    child: Icon(
                      Icons.assignment_outlined,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color:
                                isDark ? Colors.white : const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          customer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Badge(label: status, color: statusColor),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _InfoBox(
                      label: 'Date',
                      value: transactionDate,
                      icon: Icons.event_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoBox(
                      label: 'Delivery',
                      value: deliveryDate,
                      icon: Icons.local_shipping_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _InfoBox(
                label: 'Grand Total',
                value: grandTotal,
                icon: Icons.payments_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: isDark ? const Color(0xFF0B1228) : const Color(0xFFF7F8FC),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '-' : value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.withValues(alpha: .12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}

class _PremiumEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _PremiumEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
      ),
      child: Column(
        children: [
          Icon(icon, size: 54, color: const Color(0xFFE74C3C)),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrdersLoading extends StatelessWidget {
  const _OrdersLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _OrdersError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _OrdersError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: _PremiumEmptyState(
        icon: Icons.error_outline,
        title: l10n.somethingWentWrong,
        message: message,
        actionLabel: l10n.retry,
        onAction: onRetry,
      ),
    );
  }
}