import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:erp_sales/core/helpers/app_toast.dart';
import 'package:erp_sales/features/hr/data/models/employee_model.dart';
import 'package:erp_sales/features/hr/data/repo/employees_repository.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_form_widgets.dart';

class CreateEmployeeScreen extends StatefulWidget {
  const CreateEmployeeScreen({super.key});

  @override
  State<CreateEmployeeScreen> createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  bool isLoading = true;
  bool isSubmitting = false;
  String? errorMessage;

  List<String> companies = [];
  List<String> departments = [];
  List<String> designations = [];

  final List<String> genders = const ['Male', 'Female'];

  String? selectedGender = 'Male';
  String? selectedCompany;
  String? selectedDepartment;
  String? selectedDesignation;

  DateTime? dateOfJoining = DateTime.now();
  DateTime? dateOfBirth = DateTime(1995, 1, 1);

  @override
  void initState() {
    super.initState();
    loadFormData();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> loadFormData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final repository = context.read<EmployeesRepository>();
      final companiesResult = await repository.getCompanies();
      final departmentsResult = await repository.getDepartments();
      final designationsResult = await repository.getDesignations();

      if (!mounted) return;

      setState(() {
        companies = companiesResult;
        departments = departmentsResult;
        designations = designationsResult;

        if (companies.isNotEmpty) selectedCompany = companies.first;
        if (departments.isNotEmpty) selectedDepartment = departments.first;
        if (designations.isNotEmpty) selectedDesignation = designations.first;

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

  Future<void> pickJoiningDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateOfJoining ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => dateOfJoining = picked);
    }
  }

  Future<void> pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth ?? DateTime(1995, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => dateOfBirth = picked);
    }
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedGender == null) return AppToast.error('Please select gender');
    if (selectedCompany == null) return AppToast.error('Please select company');
    if (dateOfJoining == null) return AppToast.error('Please select date of joining');
    if (dateOfBirth == null) return AppToast.error('Please select date of birth');

    setState(() => isSubmitting = true);

    try {
      final repository = context.read<EmployeesRepository>();
      final request = CreateEmployeeRequest(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        gender: selectedGender!,
        dateOfJoining: _formatDate(dateOfJoining!),
        dateOfBirth: _formatDate(dateOfBirth!),
        company: selectedCompany!,
        department: selectedDepartment,
        designation: selectedDesignation,
      );

      await repository.createEmployee(request);

      if (!mounted) return;
      AppToast.success('Employee created successfully');
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
    final primaryColor = const Color(0xFF9B59B6);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return Scaffold(
        backgroundColor: bg,
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(title: const Text('Add Employee'), centerTitle: true),
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
          'Add Employee',
          style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      bottomNavigationBar: HrFormSubmitButton(
        isSubmitting: isSubmitting,
        onPressed: submit,
        label: 'Create Employee',
      ),
      body: AbsorbPointer(
        absorbing: isSubmitting,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
              HrFormHeroHeader(
                icon: Icons.person_add_alt_1_outlined,
                title: 'Add Employee',
                subtitle: 'Create a new HR employee profile',
                primaryColor: primaryColor,
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF020617), const Color(0xFF231942), const Color(0xFF101A35)]
                      : [const Color(0xFFF5F3FF), Colors.white],
                ),
              ),
              const SizedBox(height: 18),
              HrFormSectionCard(
                children: [
                  const HrFormLabel(text: 'Personal Information'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: firstNameController,
                    decoration: hrFormInputDecoration(context, 'First Name', prefixIcon: Icons.person_outline),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: lastNameController,
                    decoration: hrFormInputDecoration(context, 'Last Name', prefixIcon: Icons.person_outline),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: subText),
                    style: TextStyle(color: text, fontSize: 14),
                    decoration: hrFormInputDecoration(context, 'Gender', prefixIcon: Icons.wc_outlined),
                    items: genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (v) => setState(() => selectedGender = v),
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),
                  HrFormDateTile(
                    title: 'Date of Birth',
                    value: _formatDate(dateOfBirth!),
                    onTap: pickBirthDate,
                    primaryColor: primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              HrFormSectionCard(
                children: [
                  const HrFormLabel(text: 'Company Information'),
                  const SizedBox(height: 16),
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
                    value: selectedDepartment,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: subText),
                    style: TextStyle(color: text, fontSize: 14),
                    decoration: hrFormInputDecoration(context, 'Department', prefixIcon: Icons.apartment_outlined),
                    items: departments.map((d) => DropdownMenuItem(value: d, child: Text(d, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setState(() => selectedDepartment = v),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: selectedDesignation,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: subText),
                    style: TextStyle(color: text, fontSize: 14),
                    decoration: hrFormInputDecoration(context, 'Designation', prefixIcon: Icons.work_outline),
                    items: designations.map((d) => DropdownMenuItem(value: d, child: Text(d, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (v) => setState(() => selectedDesignation = v),
                  ),
                  const SizedBox(height: 14),
                  HrFormDateTile(
                    title: 'Date of Joining',
                    value: _formatDate(dateOfJoining!),
                    onTap: pickJoiningDate,
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
