import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/features/auth/presentation/screens/profile_screen.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_notes_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoices_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_order_details_repository.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/delivery_notes_screen.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_invoice_screen.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_orders_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'package:erp_sales/features/items/data/repo/item_details_repository.dart';
import 'package:erp_sales/features/items/presentation/screens/items_screen.dart';
import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';
import 'package:erp_sales/features/customers/presentation/screens/customers_screen.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_orders_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final deliveryNotesListRepository = context
        .read<DeliveryNotesListRepository>();
    final itemsRepository = context.read<ItemsRepository>();
    final itemDetailsRepository = context.read<ItemDetailsRepository>();
    final customersRepository = context.read<CustomersRepository>();
    final salesOrdersListRepository = context.read<SalesOrdersListRepository>();
    final salesOrderDetailsRepository = context
        .read<SalesOrderDetailsRepository>();
    final deliveryNoteRepository = context.read<DeliveryNoteRepository>();
    final salesInvoiceRepository = context.read<SalesInvoiceRepository>();
    final salesInvoicesListRepository = context.read<SalesInvoicesListRepository>();
    final authRepository = context.read<AuthRepository>();
    final deliveryNoteDetailsRepository = context.read<DeliveryNoteDetailsRepository>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.erpSalesDashboard),
        centerTitle: true,
        elevation: 0,
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.primary,
        foregroundColor:
            Theme.of(context).appBarTheme.foregroundColor ?? Colors.white,
        actions: [
          IconButton(
            tooltip: l10n.profile,
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(authRepository: authRepository),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).appBarTheme.backgroundColor ??
                  Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcomeToYourErp,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color:
                        Theme.of(context).appBarTheme.foregroundColor ??
                        Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.manageYourSalesEfficiently,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        (Theme.of(context).appBarTheme.foregroundColor ??
                                Colors.white)
                            .withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _DashboardCard(
                        icon: Icons.inventory_2_outlined,
                        title: l10n.items,
                        subtitle: l10n.productCatalog,
                        iconColor: const Color(0xFF3498DB),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ItemsScreen(
                                itemsRepository: itemsRepository,
                                itemDetailsRepository: itemDetailsRepository,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DashboardCard(
                        icon: Icons.people_outline,
                        title: l10n.customers,
                        subtitle: l10n.clientDirectory,
                        iconColor: const Color(0xFF2ECC71),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomersScreen(
                                customersRepository: customersRepository,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DashboardCard(
                        icon: Icons.assignment_outlined,
                        title: l10n.salesOrders,
                        subtitle: l10n.orderManagement,
                        iconColor: const Color(0xFFE74C3C),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SalesOrdersScreen(
                                salesOrdersListRepository:
                                    salesOrdersListRepository,
                                salesOrderDetailsRepository:
                                    salesOrderDetailsRepository,
                                deliveryNoteRepository: deliveryNoteRepository,
                                salesInvoiceRepository: salesInvoiceRepository,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DashboardCard(
                        icon: Icons.receipt_long_outlined,
                        title: l10n.salesInvoices,
                        subtitle: l10n.salesInvoices,
                        iconColor: const Color(0xFF9B59B6),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SalesInvoicesScreen(
                                salesInvoicesListRepository:
                                    salesInvoicesListRepository,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _DashboardCard(
                  icon: Icons.local_shipping_outlined,
                  title: l10n.deliveryNotes,
                  subtitle: l10n.shipmentTracking,
                  iconColor: const Color(0xFFF39C12),
                  fullWidth: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeliveryNotesScreen(
                          deliveryNotesListRepository:
                              deliveryNotesListRepository,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;
  final bool fullWidth;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 14,
                offset: const Offset(0, 6),
                color: Theme.of(context).shadowColor.withValues(alpha: 0.06),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: iconColor.withValues(alpha: 0.14),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style:
                    Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ) ??
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style:
                    Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ) ??
                    TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.35,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
