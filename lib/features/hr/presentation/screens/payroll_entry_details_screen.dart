import 'package:erp_sales/core/helpers/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:erp_sales/features/hr/data/repo/payroll_repository.dart';

class PayrollEntryDetailsScreen extends StatefulWidget {
  final String name;

  const PayrollEntryDetailsScreen({super.key, required this.name});

  @override
  State<PayrollEntryDetailsScreen> createState() =>
      _PayrollEntryDetailsScreenState();
}

class _PayrollEntryDetailsScreenState extends State<PayrollEntryDetailsScreen> {
  bool isLoading = true;
  String? error;
  Map<String, dynamic>? data;
  String? loadingAction;

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  Future<void> loadDetails() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final repo = context.read<PayrollRepository>();
      final result = await repo.getPayrollEntryDetails(widget.name);

      if (!mounted) return;

      setState(() {
        data = result;
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

  Future<void> createSalarySlips() async {
    if (loadingAction == 'create' || data == null) return;
    setState(() => loadingAction = 'create');

    try {
      final repo = context.read<PayrollRepository>();
      await repo.createSalarySlips(data!);

      if (!mounted) return;

      AppToast.success('Salary slips created successfully');
      await loadDetails();
    } catch (e) {
      if (!mounted) return;
      AppToast.error(e.toString());
    } finally {
      if (mounted) setState(() => loadingAction = null);
    }
  }

  Future<void> submitSalarySlips() async {
    if (loadingAction == 'submit' || data == null) return;
    setState(() => loadingAction = 'submit');

    try {
      final repo = context.read<PayrollRepository>();
      await repo.submitSalarySlips(data!);

      if (!mounted) return;

      AppToast.success('Salary slips submitted successfully');
      await loadDetails();
    } catch (e) {
      if (!mounted) return;
      AppToast.error(e.toString());
    } finally {
      if (mounted) setState(() => loadingAction = null);
    }
  }

  Future<void> makeBankEntry() async {
    if (loadingAction == 'bank' || data == null) return;
    setState(() => loadingAction = 'bank');

    try {
      final repo = context.read<PayrollRepository>();

      await repo.makeBankEntry(doc: data!, paymentAccount: '1110 - Cash - S');

      if (!mounted) return;

      AppToast.success('Bank entry created successfully');
      await loadDetails();
    } catch (e) {
      if (!mounted) return;
      AppToast.error(e.toString());
    } finally {
      if (mounted) setState(() => loadingAction = null);
    }
  }

  Future<void> getEmployees() async {
    if (loadingAction == 'employees' || data == null) return;

    setState(() => loadingAction = 'employees');

    try {
      final repo = context.read<PayrollRepository>();

      await repo.addEmployeeToPayrollEntry(data!);

      if (!mounted) return;

      AppToast.success('Employee added successfully');
      await loadDetails();
    } catch (e) {
      if (!mounted) return;
      AppToast.error(e.toString());
    } finally {
      if (mounted) setState(() => loadingAction = null);
    }
  }

  String value(String key) {
    final v = data?[key];
    if (v == null) return '-';
    return v.toString();
  }

  Widget infoCard({
    required IconData icon,
    required String title,
    required String val,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).cardColor,
        border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: .16)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2563EB)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(val, style: const TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget employeesSection() {
    final employeesRaw = data?['employees'];

    if (employeesRaw is! List || employeesRaw.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Theme.of(context).cardColor,
        border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: .16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Employees',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          ...employeesRaw.map((item) {
            final map = Map<String, dynamic>.from(item as Map);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFF2563EB).withValues(alpha: .06),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_outline, color: Color(0xFF2563EB)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          map['employee_name']?.toString() ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          map['employee']?.toString() ?? '-',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text(widget.name), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: loadDetails,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 100),
                  const Icon(Icons.error_outline, size: 56, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(error!, textAlign: TextAlign.center),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF020617), const Color(0xFF0F172A)]
                            : [const Color(0xFFEFF6FF), Colors.white],
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.payments_outlined,
                          size: 42,
                          color: Color(0xFF2563EB),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${value('start_date')} → ${value('end_date')}',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  infoCard(
                    icon: Icons.business_outlined,
                    title: 'Company',
                    val: value('company'),
                  ),
                  infoCard(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Payable Account',
                    val: value('payroll_payable_account'),
                  ),
                  infoCard(
                    icon: Icons.info_outline,
                    title: 'Status',
                    val: value('status'),
                  ),
                  infoCard(
                    icon: Icons.calendar_month_outlined,
                    title: 'Posting Date',
                    val: value('posting_date'),
                  ),
                  employeesSection(),

                  _ActionButton(
                    label: 'Get Employees',
                    icon: Icons.people_outline,
                    isLoading: loadingAction == 'employees',
                    onPressed: getEmployees,
                  ),

                  const SizedBox(height: 12),
                  _ActionButton(
                    label: 'Create Salary Slips',
                    icon: Icons.receipt_long_outlined,
                    isLoading: loadingAction == 'create',
                    onPressed: createSalarySlips,
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    label: 'Submit Salary Slips',
                    icon: Icons.verified_outlined,
                    isLoading: loadingAction == 'submit',
                    onPressed: submitSalarySlips,
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    label: 'Make Bank Entry',
                    icon: Icons.account_balance_outlined,
                    isLoading: loadingAction == 'bank',
                    onPressed: makeBankEntry,
                  ),
                ],
              ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isLoading;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(icon),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}
