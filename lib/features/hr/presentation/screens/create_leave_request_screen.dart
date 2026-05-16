import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:erp_sales/core/helpers/app_toast.dart';
import 'package:erp_sales/features/hr/data/models/leave_request_model.dart';
import 'package:erp_sales/features/hr/data/repo/leave_requests_repository.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_form_widgets.dart';

class CreateLeaveRequestScreen extends StatefulWidget {
  const CreateLeaveRequestScreen({super.key});

  @override
  State<CreateLeaveRequestScreen> createState() => _CreateLeaveRequestScreenState();
}

class _CreateLeaveRequestScreenState extends State<CreateLeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();

  bool isLoading = true;
  bool isSubmitting = false;
  String? errorMessage;

  List<Map<String, dynamic>> employees = [];
  List<String> leaveTypes = [];

  String? selectedEmployee;
  String? selectedLeaveType;
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    loadFormData();
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  Future<void> loadFormData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final repository = context.read<LeaveRequestsRepository>();
      final employeesResult = await repository.getEmployees();
      final leaveTypesResult = await repository.getLeaveTypes();

      if (!mounted) return;

      setState(() {
        employees = employeesResult;
        leaveTypes = leaveTypesResult;

        if (employees.isNotEmpty) {
          selectedEmployee = employees.first['name'].toString();
        }
        if (leaveTypes.isNotEmpty) {
          selectedLeaveType = leaveTypes.first;
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

  Future<void> pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      builder: _datePickerTheme,
    );

    if (picked != null) {
      setState(() {
        fromDate = picked;
        if (toDate != null && toDate!.isBefore(picked)) {
          toDate = picked;
        }
      });
    }
  }

  Future<void> pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? fromDate ?? DateTime.now(),
      firstDate: fromDate ?? DateTime(2024),
      lastDate: DateTime(2035),
      builder: _datePickerTheme,
    );

    if (picked != null) {
      setState(() {
        toDate = picked;
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

    final employeeToSubmit = selectedEmployee ?? (employees.isNotEmpty ? employees.first['name']?.toString() : null);
    final leaveTypeToSubmit = selectedLeaveType ?? (leaveTypes.isNotEmpty ? leaveTypes.first : null);

    if (employeeToSubmit == null || employeeToSubmit.isEmpty) {
      AppToast.error('Please select employee');
      return;
    }

    if (leaveTypeToSubmit == null || leaveTypeToSubmit.isEmpty) {
      AppToast.error('Please select leave type');
      return;
    }

    if (fromDate == null || toDate == null) {
      AppToast.error('Please select from and to dates');
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final repository = context.read<LeaveRequestsRepository>();
      final request = CreateLeaveRequestRequest(
        employee: employeeToSubmit,
        leaveType: leaveTypeToSubmit,
        fromDate: _formatDate(fromDate!),
        toDate: _formatDate(toDate!),
        reason: reasonController.text.trim(),
      );

      await repository.createLeaveRequest(request);

      if (!mounted) return;
      AppToast.success('Leave request created successfully');
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
        appBar: AppBar(title: const Text('Create Leave Request'), centerTitle: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.redAccent),
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
          'Create Leave Request',
          style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      bottomNavigationBar: HrFormSubmitButton(
        isSubmitting: isSubmitting,
        onPressed: submit,
        label: 'Submit Leave Request',
      ),
      body: AbsorbPointer(
        absorbing: isSubmitting,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
              HrFormHeroHeader(
                icon: Icons.event_available_rounded,
                title: 'New Leave Request',
                subtitle: 'Select employee, leave type and request dates',
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
                  const HrFormLabel(text: 'Leave Type'),
                  DropdownButtonFormField<String>(
                    value: selectedLeaveType,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: subText),
                    style: TextStyle(color: text, fontSize: 14),
                    decoration: hrFormInputDecoration(context, 'Select leave type'),
                    items: leaveTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedLeaveType = value),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              HrFormSectionCard(
                children: [
                  HrFormDateTile(
                    title: 'From Date',
                    value: fromDate == null ? 'Select date' : _formatDate(fromDate!),
                    onTap: pickFromDate,
                  ),
                  const SizedBox(height: 12),
                  HrFormDateTile(
                    title: 'To Date',
                    value: toDate == null ? 'Select date' : _formatDate(toDate!),
                    onTap: pickToDate,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              HrFormSectionCard(
                children: [
                  const HrFormLabel(text: 'Reason'),
                  TextFormField(
                    controller: reasonController,
                    maxLines: 5,
                    style: TextStyle(color: text),
                    decoration: hrFormInputDecoration(context, 'Write reason here...'),
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
