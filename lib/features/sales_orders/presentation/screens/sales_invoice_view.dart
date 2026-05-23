import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_details_repository.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_invoice_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/sales_orders/presentation/cubit/sales_invoice_cubit.dart';
import 'package:erp_sales/features/sales_orders/presentation/cubit/sales_invoice_state.dart';
import 'package:erp_sales/core/helpers/app_toast.dart';
import '../widgets/invoice_header_bar.dart';
import '../widgets/invoice_search_bar.dart';
import '../widgets/invoice_card.dart';
import '../widgets/invoice_empty_state.dart';
import '../widgets/invoice_error_state.dart';

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
      backgroundColor: isDark
          ? _backgroundDark
          : Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<SalesInvoicesCubit, SalesInvoicesState>(
          builder: (context, state) {
            if (state is SalesInvoicesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SalesInvoicesError) {
              return InvoiceErrorState(
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
                    InvoiceHeaderBar(
                      onBack: () => Navigator.pop(context),
                      onAdd: _showCreateInvoiceInfo,
                    ),
                    const SizedBox(height: 18),
                    InvoiceSearchBar(
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
                      InvoiceEmptyState(
                        title: state.invoices.isEmpty
                            ? 'No invoices yet'
                            : 'No matching invoices',
                        subtitle: state.invoices.isEmpty
                            ? 'Invoices you create will appear here'
                            : 'Try another keyword or filter.',
                      ),
                    ] else ...[
                      ...filteredInvoices.map(
                        (invoice) => InvoiceCard(
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