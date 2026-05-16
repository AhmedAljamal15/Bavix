import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:erp_sales/features/hr/data/repo/payroll_repository.dart';

class SalarySlipDetailsScreen extends StatefulWidget {
  final String name;

  const SalarySlipDetailsScreen({
    super.key,
    required this.name,
  });

  @override
  State<SalarySlipDetailsScreen> createState() =>
      _SalarySlipDetailsScreenState();
}

class _SalarySlipDetailsScreenState extends State<SalarySlipDetailsScreen> {
  bool isLoading = true;
  String? error;
  Map<String, dynamic>? data;

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
      final result = await repo.getSalarySlipDetails(widget.name);

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

  String value(String key) {
    final v = data?[key];
    if (v == null) return '-';
    return v.toString();
  }

  Widget infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: const Color(0xFF2563EB).withValues(alpha: .16),
        ),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
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

  Widget amountSection(String title, String key) {
    final itemsRaw = data?[key];

    if (itemsRaw is! List || itemsRaw.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: const Color(0xFF2563EB).withValues(alpha: .16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          ...itemsRaw.map((item) {
            final map = Map<String, dynamic>.from(item as Map);
            final component =
                map['salary_component']?.toString() ?? '-';
            final amount = map['amount']?.toString() ?? '0';

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      component,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
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
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: loadDetails,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      const SizedBox(height: 100),
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 56,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        error!,
                        textAlign: TextAlign.center,
                      ),
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
                                ? [
                                    const Color(0xFF020617),
                                    const Color(0xFF0F172A),
                                  ]
                                : [
                                    const Color(0xFFEFF6FF),
                                    Colors.white,
                                  ],
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.receipt_long_outlined,
                              color: Color(0xFF2563EB),
                              size: 42,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              value('employee_name').isEmpty
                                  ? value('employee')
                                  : value('employee_name'),
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
                                color: isDark
                                    ? Colors.white70
                                    : Colors.black54,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      infoTile(
                        icon: Icons.badge_outlined,
                        title: 'Employee',
                        value: value('employee'),
                      ),
                      infoTile(
                        icon: Icons.business_outlined,
                        title: 'Company',
                        value: value('company'),
                      ),
                      infoTile(
                        icon: Icons.info_outline,
                        title: 'Status',
                        value: value('status'),
                      ),
                      infoTile(
                        icon: Icons.payments_outlined,
                        title: 'Gross Pay',
                        value: value('gross_pay'),
                      ),
                      infoTile(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'Net Pay',
                        value: value('net_pay'),
                      ),
                      amountSection('Earnings', 'earnings'),
                      amountSection('Deductions', 'deductions'),
                    ],
                  ),
      ),
    );
  }
}