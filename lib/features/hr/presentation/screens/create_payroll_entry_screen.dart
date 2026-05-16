import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:erp_sales/core/helpers/app_toast.dart';
import 'package:erp_sales/features/hr/data/models/payroll_model.dart';
import 'package:erp_sales/features/hr/data/repo/payroll_repository.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_form_widgets.dart';

class CreatePayrollEntryScreen extends StatefulWidget {
  const CreatePayrollEntryScreen({super.key});

  @override
  State<CreatePayrollEntryScreen> createState() => _CreatePayrollEntryScreenState();
}

class _CreatePayrollEntryScreenState extends State<CreatePayrollEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isSubmitting = false;
  String? error;

  List<String> companies = [];
  List<String> accounts = [];

  String? selectedCompany;
  String? selectedAccount;
  String currency = 'EGP';

  DateTime startDate = DateTime(2026, 4, 27);
  DateTime endDate = DateTime(2026, 5, 26);
  DateTime postingDate = DateTime(2026, 4, 27);
  DateTime employeeJoiningDate = DateTime(2026, 4, 27);

  @override
  void initState() {
    super.initState();
    loadFormData();
  }

  Future<void> loadFormData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final repo = context.read<PayrollRepository>();
      final companiesResult = await repo.getCompanies();
      final accountsResult = await repo.getAccounts();

      if (!mounted) return;

      setState(() {
        companies = companiesResult;
        accounts = accountsResult;

        if (companies.isNotEmpty) selectedCompany = companies.first;
        if (accounts.contains('2120 - Payroll Payable - S')) {
          selectedAccount = '2120 - Payroll Payable - S';
        } else if (accounts.isNotEmpty) {
          selectedAccount = accounts.first;
        }

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

  String formatDate(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }

  Future<void> pickDate({
    required DateTime initialDate,
    required ValueChanged<DateTime> onPicked,
    DateTime? firstDate,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) onPicked(picked);
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedCompany == null || selectedCompany!.isEmpty) {
      return AppToast.error('Please select company');
    }
    if (selectedAccount == null || selectedAccount!.isEmpty) {
      return AppToast.error('Please select payroll payable account');
    }
    if (startDate.isBefore(employeeJoiningDate)) {
      return AppToast.error('Start date cannot be before employee joining date');
    }
    if (endDate.isBefore(startDate)) {
      return AppToast.error('End date cannot be before start date');
    }

    setState(() => isSubmitting = true);

    try {
      final repo = context.read<PayrollRepository>();
      final request = CreatePayrollEntryRequest(
        company: selectedCompany!,
        startDate: formatDate(startDate),
        endDate: formatDate(endDate),
        postingDate: formatDate(postingDate),
        payrollPayableAccount: selectedAccount!,
        currency: currency,
        exchangeRate: 1,
      );

      await repo.createPayrollEntry(request);

      if (!mounted) return;
      AppToast.success('Payroll entry created successfully');
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      AppToast.error(e.toString());
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final text = Theme.of(context).colorScheme.onSurface;
    final subText = Theme.of(context).colorScheme.onSurfaceVariant;
    final primaryColor = const Color(0xFF2563EB);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return Scaffold(
        backgroundColor: bg,
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(title: const Text('Create Payroll Entry'), centerTitle: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: text),
        title: Text(
          'Create Payroll Entry',
          style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      bottomNavigationBar: HrFormSubmitButton(
        isSubmitting: isSubmitting,
        onPressed: submit,
        label: 'Create Payroll Entry',
      ),
      body: AbsorbPointer(
        absorbing: isSubmitting,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
              HrFormHeroHeader(
                icon: Icons.payments_outlined,
                title: 'Create Payroll Entry',
                subtitle: 'Create a payroll period and payable account.',
                primaryColor: primaryColor,
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF020617), const Color(0xFF172554), const Color(0xFF101A35)]
                      : [const Color(0xFFEFF6FF), Colors.white],
                ),
              ),
              const SizedBox(height: 18),
              HrFormSectionCard(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedCompany,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: subText),
                    style: TextStyle(color: text, fontSize: 14),
                    decoration: hrFormInputDecoration(context, 'Company', prefixIcon: Icons.business_outlined),
                    items: companies.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setState(() => selectedCompany = v),
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: selectedAccount,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: subText),
                    style: TextStyle(color: text, fontSize: 14),
                    decoration: hrFormInputDecoration(context, 'Payroll Payable Account', prefixIcon: Icons.account_balance_outlined),
                    items: accounts.map((a) => DropdownMenuItem(value: a, child: Text(a, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setState(() => selectedAccount = v),
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    initialValue: currency,
                    decoration: hrFormInputDecoration(context, 'Currency', prefixIcon: Icons.attach_money_rounded),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    onChanged: (v) => currency = v.trim(),
                  ),
                  const SizedBox(height: 14),
                  HrFormDateTile(
                    title: 'Start Date',
                    value: formatDate(startDate),
                    onTap: () => pickDate(initialDate: startDate, firstDate: employeeJoiningDate, onPicked: (picked) => setState(() => startDate = picked)),
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(height: 14),
                  HrFormDateTile(
                    title: 'End Date',
                    value: formatDate(endDate),
                    onTap: () => pickDate(initialDate: endDate, onPicked: (picked) => setState(() => endDate = picked)),
                    primaryColor: primaryColor,
                  ),
                  const SizedBox(height: 14),
                  HrFormDateTile(
                    title: 'Posting Date',
                    value: formatDate(postingDate),
                    onTap: () => pickDate(initialDate: postingDate, onPicked: (picked) => setState(() => postingDate = picked)),
                    primaryColor: primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
