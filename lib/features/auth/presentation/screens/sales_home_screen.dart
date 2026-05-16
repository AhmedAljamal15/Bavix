import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/features/auth/presentation/screens/profile_screen.dart';
import 'package:erp_sales/features/auth/presentation/widgets/permission_guard.dart';
import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';
import 'package:erp_sales/features/customers/presentation/screens/customers_screen.dart';
import 'package:erp_sales/features/items/data/repo/item_details_repository.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'package:erp_sales/features/items/presentation/screens/items_screen.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_notes_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoices_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_order_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_orders_list_repository.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/delivery_notes_screen.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_invoice_screen.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_orders_screen.dart';
import 'package:erp_sales/features/search/presentation/screens/global_search_screen.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesHomeScreen extends StatelessWidget {
  const SalesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = context.read<AuthRepository>();

    return FutureBuilder(
      future: authRepository.getCurrentPermissions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final permissions = snapshot.data!;
        if (!permissions.canViewSalesDashboard) {
          return Scaffold(body: Center(child: Text(AppLocalizations.of(context)!.noPermission),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: _SalesBody(permissions: permissions),
        );
      },
    );
  }
}

class _SalesBody extends StatelessWidget {
  final dynamic permissions;

  const _SalesBody({required this.permissions});

  @override
  Widget build(BuildContext context) {
    final authRepository = context.read<AuthRepository>();

    final itemsRepository = context.read<ItemsRepository>();
    final itemDetailsRepository = context.read<ItemDetailsRepository>();
    final customersRepository = context.read<CustomersRepository>();
    final salesOrdersListRepository = context.read<SalesOrdersListRepository>();
    final salesOrderDetailsRepository = context
        .read<SalesOrderDetailsRepository>();
    final deliveryNoteRepository = context.read<DeliveryNoteRepository>();
    final salesInvoiceRepository = context.read<SalesInvoiceRepository>();
    final salesInvoicesListRepository = context
        .read<SalesInvoicesListRepository>();
    final deliveryNotesListRepository = context
        .read<DeliveryNotesListRepository>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth > 900 ? 860.0 : double.infinity;

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            _SalesHeroHeader(
              title: AppLocalizations.of(context)!.salesDashboardTitle,
              subtitle: AppLocalizations.of(context)!.customers,
              onSearch: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GlobalSearchScreen()),
                );
              },
              onProfile: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProfileScreen(authRepository: authRepository),
                  ),
                );
              },
            ),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Section(
                        title: AppLocalizations.of(context)!.items,
                        child: _ResponsiveActions(
                          children: [
                            PermissionGuard(
                              allowed: permissions.canViewCustomers,
                              child: _ActionCard(
                                title: AppLocalizations.of(context)!.salesOrders,
                                subtitle: AppLocalizations.of(context)!.salesInvoices,
                                icon: Icons.people_outline,
                                color: const Color(0xFF2ECC71),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CustomersScreen(
                                        customersRepository:
                                            customersRepository,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            PermissionGuard(
                              allowed: permissions.canViewItems,
                              child: _ActionCard(
                                title: AppLocalizations.of(context)!.deliveryNotes,
                                subtitle: AppLocalizations.of(context)!.customers,
                                icon: Icons.inventory_2_outlined,
                                color: const Color(0xFF42A5F5),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ItemsScreen(
                                        itemsRepository: itemsRepository,
                                        itemDetailsRepository:
                                            itemDetailsRepository,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            PermissionGuard(
                              allowed: permissions.canViewOrders,
                              child: _ActionCard(
                                title: AppLocalizations.of(context)!.items,
                                subtitle: AppLocalizations.of(context)!.salesOrders,
                                icon: Icons.assignment_outlined,
                                color: const Color(0xFFE74C3C),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SalesOrdersScreen(
                                        salesOrdersListRepository:
                                            salesOrdersListRepository,
                                        salesOrderDetailsRepository:
                                            salesOrderDetailsRepository,
                                        deliveryNoteRepository:
                                            deliveryNoteRepository,
                                        salesInvoiceRepository:
                                            salesInvoiceRepository,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            PermissionGuard(
                              allowed: permissions.canViewInvoices,
                              child: _ActionCard(
                                title: AppLocalizations.of(context)!.salesInvoices,
                                subtitle: AppLocalizations.of(context)!.deliveryNotes,
                                icon: Icons.receipt_long_outlined,
                                color: const Color(0xFF9B59B6),
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
                            PermissionGuard(
                              allowed: permissions.canViewDeliveryNotes,
                              child: _ActionCard(
                                title: AppLocalizations.of(context)!.deliveryNotes,
                                subtitle: 'Track deliveries',
                                icon: Icons.local_shipping_outlined,
                                color: const Color(0xFFF39C12),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SalesHeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onSearch;
  final VoidCallback onProfile;

  const _SalesHeroHeader({
    required this.title,
    required this.subtitle,
    required this.onSearch,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 34),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF020617),
                  const Color(0xFF111A42),
                  const Color(0xFF25105A),
                ]
              : [const Color(0xFFF1F5FF), Colors.white],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 16),
            color: Colors.black.withValues(alpha: 0.12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sell_outlined, color: Color(0xFF8E44AD)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
              IconButton(
                onPressed: onSearch,
                icon: const Icon(Icons.search_rounded),
              ),
              IconButton(
                onPressed: onProfile,
                icon: const Icon(Icons.person_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            'Sales Workspace',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveActions extends StatelessWidget {
  final List<Widget> children;

  const _ResponsiveActions({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 700 ? 3 : 2;
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

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: isDark ? .12 : .04),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: isDark ? color.withValues(alpha: .08) : color.withValues(alpha: .05),
            border: Border.all(color: color.withValues(alpha: .15)),
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: color.withValues(alpha: .15),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}