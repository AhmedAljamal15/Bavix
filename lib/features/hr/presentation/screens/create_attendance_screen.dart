import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:erp_sales/core/helpers/app_toast.dart';
import 'package:erp_sales/features/hr/data/models/attendance_model.dart';
import 'package:erp_sales/features/hr/data/repo/attendance_repository.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_form_widgets.dart';

class CreateAttendanceScreen extends StatefulWidget {
  const CreateAttendanceScreen({super.key});

  @override
  State<CreateAttendanceScreen> createState() => _CreateAttendanceScreenState();
}

class _CreateAttendanceScreenState extends State<CreateAttendanceScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isSubmitting = false;
  String? errorMessage;

  List<Map<String, dynamic>> employees = [];
  List<String> companies = [];

  final List<String> statuses = const [
    'Present',
    'Absent',
    'Half Day',
    'On Leave',
  ];

  String? selectedEmployee;
  String? selectedCompany;
  String? selectedStatus = 'Present';

  DateTime? selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadFormData();
  }

  Future<void> loadFormData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final repository = context.read<AttendanceRepository>();
      final employeesResult = await repository.getEmployees();
      final companiesResult = await repository.getCompanies();

      if (!mounted) return;

      setState(() {
        employees = employeesResult;
        companies = companiesResult;
        if (employees.isNotEmpty) {
          selectedEmployee = employees.first['name'].toString();
        }
        if (companies.isNotEmpty) {
          selectedCompany = companies.first;
        }
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

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      builder: _datePickerTheme,
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _datePickerTheme(BuildContext context, Widget? child) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: theme.colorScheme.primary,
          surface: theme.colorScheme.surface,
          onSurface: theme.colorScheme.onSurface,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: theme.colorScheme.surface,
        ),
      ),
      child: child!,
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _employeeLabel(Map<String, dynamic> employee) {
    final name = employee['name']?.toString() ?? '';
    final employeeName = employee['employee_name']?.toString() ?? '';
    return employeeName.isEmpty ? name : '$employeeName ($name)';
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedEmployee == null) {
      AppToast.error('Please select employee');
      return;
    }
    if (selectedStatus == null) {
      AppToast.error('Please select status');
      return;
    }
    if (selectedDate == null) {
      AppToast.error('Please select date');
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final repository = context.read<AttendanceRepository>();
      final request = CreateAttendanceRequest(
        employee: selectedEmployee!,
        attendanceDate: _formatDate(selectedDate!),
        status: selectedStatus!,
        company: selectedCompany,
      );

      await repository.createAttendance(request);

      if (!mounted) return;
      AppToast.success('Attendance created successfully');
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      AppToast.error(e.toString());
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Widget _statusDot(String status) {
    Color color;
    switch (status) {
      case 'Present': color = Colors.green; break;
      case 'Absent': color = Colors.redAccent; break;
      case 'Half Day': color = Colors.orange; break;
      case 'On Leave': color = Colors.blueAccent; break;
      default: color = Theme.of(context).colorScheme.primary;
    }
    return Container(
      height: 9, width: 9,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final text = Theme.of(context).colorScheme.onSurface;
    final subText = Theme.of(context).colorScheme.onSurfaceVariant;

    if (isLoading) {
      return Scaffold(
        backgroundColor: bg,
        body: Center(child: CircularProgressIndicator(color: primary)),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(title: const Text('Create Attendance'), centerTitle: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
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
          'Create Attendance',
          style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      bottomNavigationBar: HrFormSubmitButton(
        isSubmitting: isSubmitting,
        onPressed: submit,
        label: 'Submit Attendance',
      ),
      body: AbsorbPointer(
        absorbing: isSubmitting,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
              HrFormHeroHeader(
                icon: Icons.fact_check_rounded,
                title: 'New Attendance',
                subtitle: 'Create employee attendance record quickly',
                primaryColor: primary,
                gradient: LinearGradient(
                  colors: [primary, Theme.of(context).colorScheme.secondary, Theme.of(context).colorScheme.tertiary],
                ),
              ),
              const SizedBox(height: 18),
              HrFormSectionCard(
                children: [
                  const HrFormLabel(text: 'Employee'),
                  DropdownButtonFormField<String>(
                    value: selectedEmployee,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: subText),
                    style: TextStyle(color: text, fontSize: 14),
                    decoration: hrFormInputDecoration(context, 'Select employee'),
                    items: employees.map((employee) {
                      return DropdownMenuItem<String>(
                        value: employee['name'].toString(),
                        child: Text(_employeeLabel(employee), overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedEmployee = value),
                  ),
                  const SizedBox(height: 16),
                  const HrFormLabel(text: 'Status'),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: subText),
                    style: TextStyle(color: text, fontSize: 14),
                    decoration: hrFormInputDecoration(context, 'Select status'),
                    items: statuses.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Row(
                          children: [
                            _statusDot(status),
                            const SizedBox(width: 10),
                            Text(status),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedStatus = value),
                  ),
                  const SizedBox(height: 16),
                  const HrFormLabel(text: 'Company'),
                  DropdownButtonFormField<String>(
                    value: selectedCompany,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: subText),
                    style: TextStyle(color: text, fontSize: 14),
                    decoration: hrFormInputDecoration(context, 'Select company'),
                    items: companies.map((company) {
                      return DropdownMenuItem<String>(
                        value: company,
                        child: Text(company, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedCompany = value),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              HrFormSectionCard(
                children: [
                  HrFormDateTile(
                    title: 'Attendance Date',
                    value: selectedDate == null ? 'Select date' : _formatDate(selectedDate!),
                    onTap: pickDate,
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