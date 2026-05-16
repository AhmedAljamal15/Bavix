import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_details_repository.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_invoice_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/sales_orders/presentation/cubit/sales_invoice_cubit.dart';
import 'package:erp_sales/features/sales_orders/presentation/cubit/sales_invoice_state.dart';
import 'package:erp_sales/core/helpers/app_toast.dart';

class SalesInvoicesView extends StatefulWidget {
  const SalesInvoicesView({super.key});

  @override
  State<SalesInvoicesView> createState() => _SalesInvoicesViewState();
}

class _SalesInvoicesViewState extends State<SalesInvoicesView> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  String? _statusFilter;

  static const Color _backgroundDark = Color(0xFF020617);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return const Color(0xFF2ECC71);
      case 'unpaid':
        return const Color(0xFFF39C12);
      case 'overdue':
        return const Color(0xFFE74C3C);
      case 'draft':
        return const Color(0xFF42A5F5);
      default:
        return Colors.grey;
    }
  }

  void _showCreateInvoiceInfo() {
    AppToast.info('Create invoice from a Sales Order details screen.');
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.allInvoices),
                trailing: _statusFilter == null
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () {
                  setState(() => _statusFilter = null);
                  Navigator.pop(context);
                },
              ),
              for (final status in ['Draft', 'Paid', 'Unpaid', 'Overdue'])
                ListTile(
                  title: Text(status),
                  trailing: _statusFilter == status
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: () {
                    setState(() => _statusFilter = status);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<SalesInvoiceDetailsRepository>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? _backgroundDark : Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<SalesInvoicesCubit, SalesInvoicesState>(
          builder: (context, state) {
            if (state is SalesInvoicesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SalesInvoicesError) {
              return _ErrorState(
                message: state.message,
                onRetry: () =>
                    context.read<SalesInvoicesCubit>().getSalesInvoices(),
              );
            }

            if (state is SalesInvoicesSuccess) {
              final filteredInvoices = state.invoices.where((invoice) {
                final q = _query.toLowerCase().trim();

                final matchesSearch = q.isEmpty ||
                    invoice.name.toLowerCase().contains(q) ||
                    invoice.customer.toLowerCase().contains(q) ||
                    invoice.status.toLowerCase().contains(q) ||
                    invoice.postingDate.toLowerCase().contains(q);

                final matchesFilter =
                    _statusFilter == null || invoice.status == _statusFilter;

                return matchesSearch && matchesFilter;
              }).toList();

              return RefreshIndicator(
                onRefresh: () =>
                    context.read<SalesInvoicesCubit>().getSalesInvoices(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                  children: [
                    _HeaderBar(
                      onBack: () => Navigator.pop(context),
                      onAdd: _showCreateInvoiceInfo,
                    ),
                    const SizedBox(height: 18),
                    _SearchBar(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() => _query = value);
                      },
                      onClear: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      onFilter: _showFilterSheet,
                    ),
                    const SizedBox(height: 18),
                    if (filteredInvoices.isEmpty) ...[
                      const SizedBox(height: 80),
                      _EmptyState(
                        title: state.invoices.isEmpty
                            ? 'No invoices yet'
                            : 'No matching invoices',
                        subtitle: state.invoices.isEmpty
                            ? 'Invoices you create will appear here'
                            : 'Try another keyword or filter.',
                      ),
                    ] else ...[
                      ...filteredInvoices.map(
                        (invoice) => _InvoiceCard(
                          invoiceId: invoice.name,
                          customer: invoice.customer,
                          postingDate: invoice.postingDate,
                          total: '${invoice.grandTotal} ${invoice.currency}',
                          status: invoice.status,
                          statusColor: _statusColor(invoice.status),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SalesInvoiceDetailsScreen(
                                  invoiceId: invoice.name,
                                  repository: repo,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onAdd;

  const _HeaderBar({
    required this.onBack,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        const Icon(
          Icons.receipt_long_outlined,
          color: Color(0xFF60A5FA),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Sales Invoices',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        InkWell(
          onTap: onAdd,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1D4ED8),
                  Color(0xFF2563EB),
                ],
              ),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onFilter;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: isDark ? .14 : .05),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
              decoration: InputDecoration(
                hintText: 'Search invoices...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              onPressed: onClear,
              icon: Icon(
                Icons.close_rounded,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          IconButton(
            onPressed: onFilter,
            icon: Icon(
              Icons.filter_alt_outlined,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final String invoiceId;
  final String customer;
  final String postingDate;
  final String total;
  final String status;
  final Color statusColor;
  final VoidCallback onTap;

  const _InvoiceCard({
    required this.invoiceId,
    required this.customer,
    required this.postingDate,
    required this.total,
    required this.status,
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
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isDark ? const Color(0xFF101A35) : Colors.white,
            border: Border.all(
              color: const Color(0xFF3B82F6).withValues(alpha: .35),
            ),
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
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF1E3A8A).withValues(alpha: .55),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      color: Color(0xFF60A5FA),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      invoiceId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _StatusBadge(
                    title: status,
                    color: statusColor,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _InfoRow(Icons.person_outline, customer),
              const SizedBox(height: 10),
              _InfoRow(Icons.calendar_month_outlined, postingDate),
              const SizedBox(height: 10),
              _InfoRow(Icons.payments_outlined, total),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String value;

  const _InfoRow(this.icon, this.value);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF60A5FA),
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 15,
            ),
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: isDark ? Colors.white24 : Colors.black26,
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String title;
  final Color color;

  const _StatusBadge({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Icon(
          Icons.receipt_long_outlined,
          size: 74,
          color: const Color(0xFF60A5FA).withValues(alpha: .45),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black54,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isDark ? const Color(0xFF101A35) : Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 54,
              ),
              const SizedBox(height: 14),
              Text(
                'Something went wrong',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
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
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}