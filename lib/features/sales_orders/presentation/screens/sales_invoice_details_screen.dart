import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_details_repository.dart';

class SalesInvoiceDetailsScreen extends StatefulWidget {
  final String invoiceId;
  final SalesInvoiceDetailsRepository repository;

  const SalesInvoiceDetailsScreen({
    super.key,
    required this.invoiceId,
    required this.repository,
  });

  @override
  State<SalesInvoiceDetailsScreen> createState() =>
      _SalesInvoiceDetailsScreenState();
}

class _SalesInvoiceDetailsScreenState extends State<SalesInvoiceDetailsScreen> {
  dynamic invoice;
  bool isLoading = true;
  String? errorMessage;

  static const Color primary = Color(0xFF60A5FA);
  static const Color cardDark = Color(0xFF101A35);
  static const Color bgDark = Color(0xFF020617);

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final result = await widget.repository.getSalesInvoiceDetails(
        widget.invoiceId,
      );

      if (!mounted) return;

      setState(() {
        invoice = result;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return const Scaffold(
        backgroundColor: bgDark,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: isDark
            ? bgDark
            : Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
          ),
        ),
      );
    }

    final statusColor = _statusColor(invoice.status);

    return Scaffold(
      backgroundColor: isDark
          ? bgDark
          : Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
          children: [
            _TopBar(
              title: invoice.name,
              onBack: () => Navigator.pop(context),
              onRefresh: load,
            ),
            const SizedBox(height: 22),
            _InvoiceHeroCard(
              invoiceId: invoice.name,
              customerName: invoice.customerName,
              customer: invoice.customer,
              postingDate: invoice.postingDate,
              status: invoice.status,
              company: invoice.company,
              currency: invoice.currency,
              totalQty: '${invoice.totalQty}',
              grandTotal: '${invoice.grandTotal} ${invoice.currency}',
              statusColor: statusColor,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined, color: primary),
                const SizedBox(width: 10),
                Text(
                  'Items (${invoice.items.length})',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...invoice.items.map<Widget>(
              (item) => _InvoiceItemCard(
                name: item.itemName,
                code: item.itemCode,
                qty: '${item.qty}',
                uom: item.uom,
                rate: '${item.rate}',
                amount: '${item.amount}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  const _TopBar({
    required this.title,
    required this.onBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert_rounded,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          onSelected: (value) {
            if (value == 'refresh') {
              onRefresh();
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh_rounded),
                  SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.refresh),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InvoiceHeroCard extends StatelessWidget {
  final String invoiceId;
  final String customerName;
  final String customer;
  final String postingDate;
  final String status;
  final String company;
  final String currency;
  final String totalQty;
  final String grandTotal;
  final Color statusColor;

  const _InvoiceHeroCard({
    required this.invoiceId,
    required this.customerName,
    required this.customer,
    required this.postingDate,
    required this.status,
    required this.company,
    required this.currency,
    required this.totalQty,
    required this.grandTotal,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF101A35), const Color(0xFF0B1228)]
              : [Colors.white, const Color(0xFFEFF6FF)],
        ),
        border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: .28)),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 12),
            color: Colors.black.withValues(alpha: isDark ? .18 : .06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBox(
                icon: Icons.receipt_long_outlined,
                color: const Color(0xFF60A5FA),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Sales Invoice',
                  style: TextStyle(
                    color: Color(0xFF60A5FA),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _Badge(label: status, color: statusColor),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            invoiceId,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 22),
          _InfoGrid(
            children: [
              _InfoCell(
                icon: Icons.person_outline,
                label: 'Customer',
                value: customerName.isEmpty ? customer : customerName,
              ),
              _InfoCell(
                icon: Icons.calendar_month_outlined,
                label: 'Posting Date',
                value: postingDate,
              ),
              _InfoCell(
                icon: Icons.flag_outlined,
                label: 'Status',
                value: status,
                valueColor: statusColor,
              ),
              _InfoCell(
                icon: Icons.business_outlined,
                label: 'Company',
                value: company,
              ),
              _InfoCell(
                icon: Icons.payments_outlined,
                label: 'Currency',
                value: currency,
              ),
              _InfoCell(
                icon: Icons.inventory_2_outlined,
                label: 'Total Qty',
                value: totalQty,
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'Grand Total',
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black54,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            grandTotal,
            style: const TextStyle(
              color: Color(0xFF60A5FA),
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final List<Widget> children;

  const _InfoGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final width = (constraints.maxWidth - spacing) / 2;

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

class _InfoCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoCell({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? const Color(0xFF020617).withValues(alpha: .65) : Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF60A5FA), size: 20),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        valueColor ??
                        (isDark ? Colors.white : const Color(0xFF111827)),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
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

class _InvoiceItemCard extends StatelessWidget {
  final String name;
  final String code;
  final String qty;
  final String uom;
  final String rate;
  final String amount;

  const _InvoiceItemCard({
    required this.name,
    required this.code,
    required this.qty,
    required this.uom,
    required this.rate,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: .18)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _IconBox(
                icon: Icons.inventory_2_outlined,
                color: const Color(0xFF60A5FA),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      code,
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _Badge(label: uom, color: const Color(0xFF60A5FA)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SmallMetric(label: 'Qty', value: qty),
              ),
              Expanded(
                child: _SmallMetric(label: 'Rate', value: rate),
              ),
              Expanded(
                child: _SmallMetric(
                  label: 'Amount',
                  value: amount,
                  highlight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallMetric extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _SmallMetric({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black45,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: highlight
                ? const Color(0xFF60A5FA)
                : isDark
                ? Colors.white70
                : Colors.black87,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconBox({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: .14),
      ),
      child: Icon(icon, color: color),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.withValues(alpha: .14),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}
