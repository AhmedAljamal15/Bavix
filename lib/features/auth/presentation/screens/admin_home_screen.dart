import 'package:erp_sales/core/widgets/ai_header_button.dart';
import 'package:erp_sales/features/ai_assistant/data/repo/ai_assistant_repository.dart';
import 'package:erp_sales/features/ai_assistant/logic/cubit/ai_assistant_cubit.dart';
import 'package:erp_sales/features/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import 'package:erp_sales/features/auth/data/models/app_permission_model.dart';
import 'package:erp_sales/features/auth/presentation/screens/access_requests_admin_screen.dart';
import 'package:erp_sales/features/items/presentation/screens/inventory_dashboard_screen.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_invoice_screen.dart';
import 'package:erp_sales/features/search/presentation/screens/global_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:erp_sales/l10n/app_localizations.dart';

import 'package:erp_sales/features/auth/data/models/hr_user_model.dart';
import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/features/auth/data/repo/hr_users_repository.dart';
import 'package:erp_sales/features/hr/presentation/screens/hr_home_screen.dart';
import 'package:erp_sales/features/auth/presentation/screens/profile_screen.dart';
import 'package:erp_sales/features/auth/presentation/screens/sales_home_screen.dart';

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
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_orders_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  bool isLoading = true;
  String? errorMessage;

  List<HrUserModel> users = [];
  List<dynamic> customers = [];
  List<dynamic> items = [];
  List<dynamic> orders = [];
  List<dynamic> invoices = [];
  List<dynamic> deliveryNotes = [];

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await Future.wait([
        context.read<HrUsersRepository>().getUsers(),
        context.read<CustomersRepository>().getCustomers(),
        context.read<ItemsRepository>().getItems(),
        context.read<SalesOrdersListRepository>().getSalesOrders(),
        context.read<SalesInvoicesListRepository>().getSalesInvoices(),
        context.read<DeliveryNotesListRepository>().getDeliveryNotes(),
      ]);

      if (!mounted) return;

      setState(() {
        users = results[0] as List<HrUserModel>;
        customers = results[1] as List<dynamic>;
        items = results[2] as List<dynamic>;
        orders = results[3] as List<dynamic>;
        invoices = results[4] as List<dynamic>;
        deliveryNotes = results[5] as List<dynamic>;
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

  String getCurrentUserFirstName() {
    final systemUsers = users.where((user) {
      return user.enabled && user.userType == 'System User';
    }).toList();

    final user = systemUsers.isNotEmpty
        ? systemUsers.first
        : users.isNotEmpty
        ? users.first
        : null;

    final fullName = (user?.fullName.isNotEmpty == true)
        ? user!.fullName
        : user?.name ?? 'User';

    return fullName.trim().split(RegExp(r'\s+')).first;
  }

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
        if (!permissions.canViewAdminDashboard) {
          return Scaffold(
            body: Center(
              child: Text(AppLocalizations.of(context)!.noPermission),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: RefreshIndicator(
            onRefresh: loadDashboard,
            child: _buildBody(context, permissions: permissions),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required AppPermissionModel permissions,
  }) {
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

    final systemUsers = users.where((u) => u.userType == 'System User').length;
    final websiteUsers = users
        .where((u) => u.userType == 'Website User')
        .length;
    final enabledUsers = users.where((u) => u.enabled).length;

    final totalInvoiceValue = invoices.fold<double>(
      0,
      (sum, invoice) => sum + ((invoice.grandTotal ?? 0) as num).toDouble(),
    );

    final recentOrders = [...orders]
      ..sort(
        (a, b) => (b.transactionDate ?? '').compareTo(a.transactionDate ?? ''),
      );

    final recentUsers = [...users]..sort((a, b) => b.name.compareTo(a.name));

    if (isLoading) {
      return ListView(
        children: [
          SizedBox(height: 260),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (errorMessage != null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 120),
          Icon(Icons.error_outline, size: 70, color: Colors.redAccent),
          const SizedBox(height: 18),
          Text(errorMessage!, textAlign: TextAlign.center),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth > 900 ? 860.0 : double.infinity;

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            _HeroHeader(
              title: AppLocalizations.of(context)!.adminDashboardTitle,
              userFirstName: getCurrentUserFirstName(),
              subtitle:
                  'Control your ERP operations, users, sales, stock, and access.',

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

              onAi: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => AiAssistantCubit(
                        context.read<AiAssistantRepository>(),
                      ),
                      child: const AiAssistantScreen(),
                    ),
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
                      _ResponsiveGrid(
                        children: [
                          _MetricCard(
                            title: AppLocalizations.of(context)!.users,
                            value: users.length.toString(),
                            icon: Icons.group_outlined,
                            color: const Color(0xFF42A5F5),
                          ),
                          _MetricCard(
                            title: AppLocalizations.of(context)!.customers,
                            value: customers.length.toString(),
                            icon: Icons.people_outline,
                            color: const Color(0xFF2ECC71),
                          ),
                          _MetricCard(
                            title: AppLocalizations.of(context)!.items,
                            value: items.length.toString(),
                            icon: Icons.inventory_2_outlined,
                            color: const Color(0xFFF39C12),
                          ),
                          _MetricCard(
                            title: AppLocalizations.of(context)!.salesOrders,
                            value: orders.length.toString(),
                            icon: Icons.assignment_outlined,
                            color: const Color(0xFFE74C3C),
                          ),
                          _MetricCard(
                            title: AppLocalizations.of(context)!.salesInvoices,
                            value: invoices.length.toString(),
                            icon: Icons.receipt_long_outlined,
                            color: const Color(0xFF9B59B6),
                          ),
                          _MetricCard(
                            title: AppLocalizations.of(context)!.deliveryNotes,
                            value: deliveryNotes.length.toString(),
                            icon: Icons.local_shipping_outlined,
                            color: const Color(0xFF16A085),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _Section(
                        title: 'Command Center',
                        child: _ResponsiveActions(
                          children: [
                            if (permissions.canViewCustomers)
                              _ActionCard(
                                title: AppLocalizations.of(context)!.customers,
                                subtitle: 'Client directory',
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
                            if (permissions.canViewItems)
                              _ActionCard(
                                title: AppLocalizations.of(context)!.items,
                                subtitle: 'Product catalog',
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
                            if (permissions.canViewInventory)
                              _ActionCard(
                                title: 'Inventory',
                                subtitle: 'Stock insights',
                                icon: Icons.warehouse_outlined,
                                color: const Color(0xFF00BCD4),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const InventoryDashboardScreen(),
                                    ),
                                  );
                                },
                              ),
                            if (permissions.canViewOrders)
                              _ActionCard(
                                title: AppLocalizations.of(
                                  context,
                                )!.salesOrders,
                                subtitle: 'Sales orders',
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
                            if (permissions.canViewInvoices)
                              _ActionCard(
                                title: AppLocalizations.of(
                                  context,
                                )!.salesInvoices,
                                subtitle: 'Billing records',
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
                            if (permissions.canViewDeliveryNotes)
                              _ActionCard(
                                title: AppLocalizations.of(
                                  context,
                                )!.deliveryNotes,
                                subtitle: 'Shipments',
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
                            if (permissions.canViewHrDashboard)
                              _ActionCard(
                                title: AppLocalizations.of(
                                  context,
                                )!.totalInvoiceValue,
                                subtitle: 'Users & people',
                                icon: Icons.badge_outlined,
                                color: const Color(0xFF16A085),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HrHomeScreen(),
                                    ),
                                  );
                                },
                              ),
                            if (permissions.canViewSalesDashboard)
                              _ActionCard(
                                title: AppLocalizations.of(
                                  context,
                                )!.quickAccess,
                                subtitle: 'Sales workspace',
                                icon: Icons.sell_outlined,
                                color: const Color(0xFF8E44AD),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SalesHomeScreen(),
                                    ),
                                  );
                                },
                              ),
                            if (permissions.canManageAccessRequests)
                              _ActionCard(
                                title: 'Access Requests',
                                subtitle: 'Approve or reject',
                                icon: Icons.admin_panel_settings_outlined,
                                color: const Color(0xFF536DFE),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const AccessRequestsAdminScreen(),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _Section(
                        title: AppLocalizations.of(context)!.userOverview,
                        child: Column(
                          children: [
                            _InsightRow(
                              label: AppLocalizations.of(context)!.enabled,
                              value: totalInvoiceValue.toStringAsFixed(2),
                            ),
                            _InsightRow(
                              label: 'Inactive',
                              value: orders.length.toString(),
                            ),
                            _InsightRow(
                              label: 'Total',
                              value: deliveryNotes.length.toString(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _Section(
                        title: AppLocalizations.of(context)!.businessSnapshot,
                        child: Column(
                          children: [
                            _InsightRow(
                              label: AppLocalizations.of(context)!.salesOrders,
                              value: enabledUsers.toString(),
                            ),
                            _InsightRow(
                              label: AppLocalizations.of(
                                context,
                              )!.salesInvoices,
                              value: systemUsers.toString(),
                            ),
                            _InsightRow(
                              label: AppLocalizations.of(context)!.customers,
                              value: websiteUsers.toString(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _Section(
                        title: AppLocalizations.of(context)!.recentUsers,
                        child: recentOrders.isEmpty
                            ? _EmptyState(
                                message: AppLocalizations.of(
                                  context,
                                )!.noUsersFound,
                              )
                            : Column(
                                children: recentOrders.take(4).map((order) {
                                  return _ActivityTile(
                                    icon: Icons.assignment_outlined,
                                    title: order.name ?? '',
                                    subtitle:
                                        '${order.customer} • ${order.status}',
                                    trailing: '${order.grandTotal}',
                                    color: const Color(0xFFE74C3C),
                                  );
                                }).toList(),
                              ),
                      ),
                      const SizedBox(height: 18),
                      _Section(
                        title: AppLocalizations.of(context)!.recentUsers,
                        child: recentUsers.isEmpty
                            ? _EmptyState(
                                message: AppLocalizations.of(
                                  context,
                                )!.noUsersFound,
                              )
                            : Column(
                                children: recentUsers.take(5).map((user) {
                                  return _UserActivityTile(user: user);
                                }).toList(),
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

class _HeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onSearch;
  final VoidCallback onProfile;
  final String userFirstName;
  final VoidCallback onAi;

  const _HeroHeader({
    required this.title,
    required this.subtitle,
    required this.onSearch,
    required this.onProfile,
    required this.userFirstName,
    required this.onAi,
  });

  String _greeting() {
    tz.initializeTimeZones();

    final cairo = tz.getLocation('Africa/Cairo');
    final egyptTime = tz.TZDateTime.now(cairo);
    final hour = egyptTime.hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour <= 23) {
      return 'Good Evening';
    } else {
      return 'Good Morning';
    }
  }

  String _firstName() {
    const fullName =
        'Ahmed Gad'; // بدلها بالداتا الحقيقية لو عندك user.fullName
    return fullName.split(' ').first;
  }

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
                  const Color(0xFF071A3D),
                  const Color(0xFF0B235A),
                ]
              : [const Color(0xFFEFF5FF), const Color(0xFFFFFFFF)],
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
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFF536DFE),
                size: 24,
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),

              AiHeaderButton(onTap: onAi),
              const SizedBox(width: 10),

              _HeaderIconButton(icon: Icons.search_rounded, onTap: onSearch),

              const SizedBox(width: 10),

              _HeaderIconButton(
                icon: Icons.account_circle_rounded,
                onTap: onProfile,
              ),
            ],
          ),

          const SizedBox(height: 28),

          Text(
            '${_greeting()}, $userFirstName 👋',
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

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? Colors.white.withValues(alpha: .08) : Colors.white,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: .08)
                : Colors.black12,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: .05),
            ),
          ],
        ),
        child: Icon(icon, size: 22, color: const Color(0xFF536DFE)),
      ),
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;

  const _ResponsiveGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 650 ? 3 : 2;
        const spacing = 11.0;
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

class _ResponsiveActions extends StatelessWidget {
  final List<Widget> children;

  const _ResponsiveActions({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 700 ? 3 : 2;
        const spacing = 12.0;
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

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(color: color.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.04),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color.withValues(alpha: 0.12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
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
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: isDark
                ? color.withValues(alpha: .08)
                : color.withValues(alpha: .05),
            border: Border.all(color: color.withValues(alpha: .15)),
          ),
          child: Row(
            children: [
              Container(
                height: 46,
                width: 46,
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
                        fontSize: 15,
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

class _InsightRow extends StatelessWidget {
  final String label;
  final String value;

  const _InsightRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final Color color;

  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? const Color(0xFF0B1228) : const Color(0xFFF7F8FC),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: .04)
              : Colors.black.withValues(alpha: .04),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserActivityTile extends StatelessWidget {
  final HrUserModel user;

  const _UserActivityTile({required this.user});

  @override
  Widget build(BuildContext context) {
    final color = user.userType == 'System User'
        ? const Color(0xFFF39C12)
        : const Color(0xFF9B59B6);

    return _ActivityTile(
      icon: Icons.person_outline,
      title: user.fullName.isEmpty ? user.name : user.fullName,
      subtitle: '${user.name} • ${user.userType}',
      trailing: user.enabled ? 'Active' : 'Off',
      color: color,
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white60
                : Colors.black54,
          ),
        ),
      ),
    );
  }
}
