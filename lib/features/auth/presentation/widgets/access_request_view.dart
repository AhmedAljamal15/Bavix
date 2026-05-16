import 'package:erp_sales/core/helpers/app_toast.dart';
import 'package:erp_sales/features/auth/data/models/access_request.dart';
import 'package:erp_sales/features/auth/presentation/access_request_state.dart';
import 'package:erp_sales/features/auth/presentation/cubit.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccessRequestView extends StatefulWidget {
  const AccessRequestView({super.key});

  @override
  State<AccessRequestView> createState() => _AccessRequestViewState();
}

class _AccessRequestViewState extends State<AccessRequestView> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();

  String selectedRole = 'Customer';

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    final request = AccessRequest(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      requestedRole: selectedRole,
      note: noteController.text.trim(),
    );

    context.read<AccessRequestCubit>().submitRequest(request);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.requestAccessTitle), centerTitle: true),
      body: BlocConsumer<AccessRequestCubit, AccessRequestState>(
        listener: (context, state) {
          if (state is AccessRequestSuccess) {
            AppToast.success(l10n.accessRequestSubmitted(state.leadName));
            Navigator.pop(context, true);
          }

          if (state is AccessRequestError) {
            AppToast.error(state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AccessRequestLoading;

          return AbsorbPointer(
            absorbing: isLoading,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          labelText: l10n.fullName,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.fullNameIsRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: l10n.email,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.emailIsRequired;
                          }
                          final emailRegex = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          );
                          if (!emailRegex.hasMatch(value.trim())) {
                            return l10n.enterValidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRole,
                        decoration: InputDecoration(
                          labelText: l10n.requestedRole,
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'Customer',
                            child: Text(l10n.customerLabel),
                          ),
                          DropdownMenuItem(
                            value: 'Sales',
                            child: Text(l10n.sales),
                          ),
                          DropdownMenuItem(value: 'HR', child: Text(l10n.hr)),
                          DropdownMenuItem(
                            value: 'Employee',
                            child: Text(l10n.employee),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value ?? 'Customer';
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: noteController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: l10n.whyDoYouNeedAccess,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: submit,
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : Text(l10n.submitRequest),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}