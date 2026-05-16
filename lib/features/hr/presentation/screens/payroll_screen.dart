import 'package:erp_sales/features/hr/data/models/payroll_model.dart';
import 'package:erp_sales/features/hr/data/repo/payroll_repository.dart';
import 'package:erp_sales/features/hr/presentation/screens/create_payroll_entry_screen.dart';
import 'package:erp_sales/features/hr/presentation/screens/payroll_entry_details_screen.dart';
import 'package:erp_sales/features/hr/presentation/screens/salary_slip_details_screen.dart';
import 'package:erp_sales/features/hr/presentation/widgets/payroll_widgets.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  bool isLoading = true;
  String? error;

  List<SalarySlipModel> slips = [];
  List<PayrollEntryModel> entries = [];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    loadData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final repo = context.read<PayrollRepository>();
      final slipsResult = await repo.getSalarySlips();
      final entriesResult = await repo.getPayrollEntries();
      if (!mounted) return;
      setState(() {
        slips = slipsResult;
        entries = entriesResult;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  int get submittedSlips =>
      slips.where((e) => e.status.toLowerCase().contains('submit')).length;
  int get draftSlips =>
      slips.where((e) => e.status.toLowerCase().contains('draft')).length;

  Color _statusColor(String value) {
    final text = value.toLowerCase();
    if (text.contains('submitted')) return const Color(0xFF2ECC71);
    if (text.contains('draft')) return const Color(0xFFF39C12);
    if (text.contains('cancel')) return const Color(0xFFE74C3C);
    return const Color(0xFF2563EB);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CreatePayrollEntryScreen()),
          );
          if (created == true && context.mounted) loadData();
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.newEntry),
      ),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: PayrollHeader(
                isDark: isDark,
                controller: controller,
                slipsCount: slips.length,
                entriesCount: entries.length,
                submittedCount: submittedSlips,
                draftCount: draftSlips,
              ),
            ),
            SliverFillRemaining(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                      ? PayrollErrorView(error: error!, onRetry: loadData)
                      : TabBarView(
                          controller: controller,
                          children: [
                            _salarySlipsView(l10n),
                            _payrollEntriesView(l10n),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _salarySlipsView(AppLocalizations l10n) {
    if (slips.isEmpty) {
      return PayrollEmptyView(
        icon: Icons.receipt_long_outlined,
        title: l10n.noSalarySlipsYet,
        subtitle: l10n.salarySlipsAppearAutomatically,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: slips.length,
      itemBuilder: (_, index) {
        final item = slips[index];
        final employeeName =
            item.employeeName.isEmpty ? item.employee : item.employeeName;
        final color = _statusColor(item.status);

        return PayrollCard(
          icon: Icons.receipt_long_outlined,
          title: employeeName,
          subtitle: item.name,
          color: color,
          status: item.status,
          details: [
            PayrollDetailLine(
              icon: Icons.date_range_outlined,
              text: '${item.startDate} → ${item.endDate}',
            ),
            PayrollDetailLine(
              icon: Icons.payments_outlined,
              text: l10n.netPay(item.netPay.toString()),
            ),
            if (item.company.isNotEmpty)
              PayrollDetailLine(icon: Icons.business_outlined, text: item.company),
          ],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SalarySlipDetailsScreen(name: item.name)),
          ),
        );
      },
    );
  }

  Widget _payrollEntriesView(AppLocalizations l10n) {
    if (entries.isEmpty) {
      return PayrollEmptyView(
        icon: Icons.account_balance_wallet_outlined,
        title: l10n.noPayrollEntriesYet,
        subtitle: l10n.payrollEntriesAppearAutomatically,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      itemCount: entries.length,
      itemBuilder: (_, index) {
        final item = entries[index];
        final color = _statusColor(item.status);

        return PayrollCard(
          icon: Icons.account_balance_wallet_outlined,
          title: item.name,
          subtitle: item.company.isEmpty ? l10n.payrollEntry : item.company,
          color: color,
          status: item.status,
          details: [
            PayrollDetailLine(
              icon: Icons.date_range_outlined,
              text: '${item.startDate} → ${item.endDate}',
            ),
            if (item.payrollPayableAccount.isNotEmpty)
              PayrollDetailLine(
                icon: Icons.account_balance_outlined,
                text: item.payrollPayableAccount,
              ),
          ],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PayrollEntryDetailsScreen(name: item.name)),
          ),
        );
      },
    );
  }
}
