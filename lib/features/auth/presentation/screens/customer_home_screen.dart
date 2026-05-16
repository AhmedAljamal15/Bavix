import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:erp_sales/core/widgets/premium_widgets.dart';
import 'package:erp_sales/core/constants/app_constants.dart';

import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/features/auth/presentation/screens/profile_screen.dart';

import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_notes_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoices_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_orders_list_repository.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  bool isLoading = true;
  String? errorMessage;
  _CustomerDashboardData? dashboardData;

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
      final authRepository = context.read<AuthRepository>();
      final customersRepository = context.read<CustomersRepository>();
      final salesOrdersListRepository = context
          .read<SalesOrdersListRepository>();
      final salesInvoicesListRepository = context
          .read<SalesInvoicesListRepository>();
      final deliveryNotesListRepository = context
          .read<DeliveryNotesListRepository>();

      final user = await authRepository.getCurrentUser();

      if (user == null) {
        setState(() {
          errorMessage = 'No logged in user found';
          isLoading = false;
        });
        return;
      }

      final customers = await customersRepository.getCustomers();

      dynamic linkedCustomer;
      try {
        linkedCustomer = customers.firstWhere(
          (customer) =>
              (customer.customerName ?? '').toString().trim().toLowerCase() ==
              user.fullName.trim().toLowerCase(),
        );
      } catch (_) {
        linkedCustomer = null;
      }

      if (linkedCustomer == null) {
        setState(() {
          dashboardData = _CustomerDashboardData(
            fullName: user.fullName,
            email: user.email,
            linkedCustomerName: null,
            orders: const [],
            invoices: const [],
            deliveryNotes: const [],
          );
          isLoading = false;
        });
        return;
      }

      final customerKey = (linkedCustomer.name ?? '').toString();
      final customerDisplayName = (linkedCustomer.customerName ?? customerKey)
          .toString();

      final orders = await salesOrdersListRepository.getSalesOrders();
      final invoices = await salesInvoicesListRepository.getSalesInvoices();
      final deliveryNotes = await deliveryNotesListRepository
          .getDeliveryNotes();

      final customerOrders = orders.where((order) {
        final value = (order.customer ?? '').toString();
        return value == customerKey || value == customerDisplayName;
      }).toList();

      final customerInvoices = invoices.where((invoice) {
        final value = (invoice.customer ?? '').toString();
        return value == customerKey || value == customerDisplayName;
      }).toList();

      final customerDeliveryNotes = deliveryNotes.where((note) {
        final value = (note.customer ?? '').toString();
        return value == customerKey || value == customerDisplayName;
      }).toList();

      customerOrders.sort(
        (a, b) => (b.transactionDate ?? '').compareTo(a.transactionDate ?? ''),
      );
      customerInvoices.sort(
        (a, b) => (b.postingDate ?? '').compareTo(a.postingDate ?? ''),
      );
      customerDeliveryNotes.sort(
        (a, b) => (b.postingDate ?? '').compareTo(a.postingDate ?? ''),
      );

      setState(() {
        dashboardData = _CustomerDashboardData(
          fullName: user.fullName,
          email: user.email,
          linkedCustomerName: customerDisplayName,
          orders: customerOrders,
          invoices: customerInvoices,
          deliveryNotes: customerDeliveryNotes,
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = context.read<AuthRepository>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.customerDashboardTitle),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Profile',
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
      body: RefreshIndicator(
        onRefresh: loadDashboard,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: List.generate(
          5,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: SkeletonLoader(height: 100),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return ErrorStateWidget(message: errorMessage!, onRetry: loadDashboard);
    }

    final data = dashboardData!;
    final linkedCustomerName = data.linkedCustomerName;

    return ListView(
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
                'Welcome, ${data.fullName}',
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
                linkedCustomerName == null
                    ? 'No linked customer profile found for this account'
                    : 'Track your orders, invoices, and deliveries',
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
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: linkedCustomerName == null
              ? _UnlinkedCustomerCard(
                  fullName: data.fullName,
                  email: data.email,
                )
              : Column(
                  children: [
                    _LinkedCustomerCard(
                      customerName: linkedCustomerName,
                      email: data.email,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: KPICard(
                            title: 'Orders',
                            value: data.orders.length.toString(),
                            icon: Icons.assignment_outlined,
                            iconColor: const Color(0xFFE74C3C),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: KPICard(
                            title: 'Invoices',
                            value: data.invoices.length.toString(),
                            icon: Icons.receipt_long_outlined,
                            iconColor: const Color(0xFF9B59B6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    KPICard(
                      title: 'Delivery Notes',
                      value: data.deliveryNotes.length.toString(),
                      icon: Icons.local_shipping_outlined,
                      iconColor: const Color(0xFFF39C12),
                    ),
                    const SizedBox(height: 20),
                    PremiumCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent Orders',
                            style: AppTypography.title2,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _RecentOrdersList(
                            orders: data.orders.take(3).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    PremiumCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent Invoices',
                            style: AppTypography.title2,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _RecentInvoicesList(
                            invoices: data.invoices.take(3).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    PremiumCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent Delivery Notes',
                            style: AppTypography.title2,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _RecentDeliveryNotesList(
                            deliveryNotes: data.deliveryNotes.take(3).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
        ),
      ],
    );
  }
}

class _CustomerDashboardData {
  final String fullName;
  final String email;
  final String? linkedCustomerName;
  final List<dynamic> orders;
  final List<dynamic> invoices;
  final List<dynamic> deliveryNotes;

  const _CustomerDashboardData({
    required this.fullName,
    required this.email,
    required this.linkedCustomerName,
    required this.orders,
    required this.invoices,
    required this.deliveryNotes,
  });
}

class _LinkedCustomerCard extends StatelessWidget {
  final String customerName;
  final String email;

  const _LinkedCustomerCard({required this.customerName, required this.email});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.12),
            child: Icon(
              Icons.person_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customerName, style: AppTypography.title2),
                const SizedBox(height: AppSpacing.xs),
                Text(email, style: AppTypography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UnlinkedCustomerCard extends StatelessWidget {
  final String fullName;
  final String email;

  const _UnlinkedCustomerCard({required this.fullName, required this.email});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        children: [
          Icon(
            Icons.link_off_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(AppLocalizations.of(context)!.noLinkedCustomerProfileFound, style: AppTypography.title2, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'User: $fullName\nEmail: $email',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Create a Customer record with the same full name, or later we can add an explicit User → Customer link.',
            textAlign: TextAlign.center,
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}

class _RecentOrdersList extends StatelessWidget {
  final List<dynamic> orders;

  const _RecentOrdersList({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.hourglass_empty,
        title: 'No orders found',
      );
    }

    return Column(
      children: orders.map((order) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(order.name ?? '', style: AppTypography.labelLarge),
          subtitle: Text(
            'Status: ${order.status} • Date: ${order.transactionDate}',
            style: AppTypography.caption,
          ),
          trailing: Text(
            '${order.grandTotal}',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
        );
      }).toList(),
    );
  }
}

class _RecentInvoicesList extends StatelessWidget {
  final List<dynamic> invoices;

  const _RecentInvoicesList({required this.invoices});

  @override
  Widget build(BuildContext context) {
    if (invoices.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.hourglass_empty,
        title: 'No invoices found',
      );
    }

    return Column(
      children: invoices.map((invoice) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(invoice.name ?? '', style: AppTypography.labelLarge),
          subtitle: Text(
            'Status: ${invoice.status} • Date: ${invoice.postingDate}',
            style: AppTypography.caption,
          ),
          trailing: Text(
            '${invoice.grandTotal} ${invoice.currency}',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
        );
      }).toList(),
    );
  }
}

class _RecentDeliveryNotesList extends StatelessWidget {
  final List<dynamic> deliveryNotes;

  const _RecentDeliveryNotesList({required this.deliveryNotes});

  @override
  Widget build(BuildContext context) {
    if (deliveryNotes.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.hourglass_empty,
        title: 'No delivery notes found',
      );
    }

    return Column(
      children: deliveryNotes.map((note) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(note.name ?? '', style: AppTypography.labelLarge),
          subtitle: Text(
            'Status: ${note.status} • Date: ${note.postingDate}',
            style: AppTypography.caption,
          ),
          trailing: Text(
            '${note.grandTotal}',
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
        );
      }).toList(),
    );
  }
}
