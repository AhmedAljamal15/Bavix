import 'package:erp_sales/features/customers/presentation/cubit/create_customer/create_customer_cubit.dart';
import 'package:erp_sales/features/customers/presentation/cubit/create_customer/create_customer_state.dart';
import 'package:erp_sales/features/customers/presentation/widgets/customer_hero_intro_card.dart';
import 'package:erp_sales/features/customers/presentation/widgets/customer_premium_text_field.dart';
import 'package:erp_sales/features/customers/presentation/widgets/customer_top_bar.dart';
import 'package:erp_sales/features/customers/presentation/widgets/customer_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:erp_sales/core/helpers/app_toast.dart';
import 'package:erp_sales/core/widgets/app_action_button.dart';
import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';
import 'package:erp_sales/l10n/app_localizations.dart';

class CreateCustomerScreen extends StatelessWidget {
  final CustomersRepository customersRepository;
  final VoidCallback? onCustomerCreated;

  const CreateCustomerScreen({
    super.key,
    required this.customersRepository,
    this.onCustomerCreated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateCustomerCubit(customersRepository),
      child: CreateCustomerView(onCustomerCreated: onCustomerCreated),
    );
  }
}

class CreateCustomerView extends StatefulWidget {
  final VoidCallback? onCustomerCreated;

  const CreateCustomerView({super.key, this.onCustomerCreated});

  @override
  State<CreateCustomerView> createState() => _CreateCustomerViewState();
}

class _CreateCustomerViewState extends State<CreateCustomerView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _customerNameController;
  late final TextEditingController emailController;
  late final FocusNode _nameFocus;
  late final FocusNode _emailFocus;

  String _selectedCustomerType = 'Individual';

  static const Color _bgDark = Color(0xFF020617);
  static const Color _cardDark = Color(0xFF101A35);

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController();
    emailController = TextEditingController();
    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    emailController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _handleCreateCustomer(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      AppToast.error('Please check the form fields');
      return;
    }

    context.read<CreateCustomerCubit>().createCustomer(
      customerName: _customerNameController.text.trim(),
      customerType: _selectedCustomerType,
      emailId: emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<CreateCustomerCubit, CreateCustomerState>(
      listener: (context, state) {
        if (state is CreateCustomerSuccess) {
          AppToast.success(l10n.customerCreatedSuccessfully);
          widget.onCustomerCreated?.call();
          Navigator.pop(context, true);
        } else if (state is CreateCustomerError) {
          AppToast.error(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: isDark
            ? _bgDark
            : Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<CreateCustomerCubit, CreateCustomerState>(
            builder: (context, state) {
              final isLoading = state is CreateCustomerLoading;

              return AbsorbPointer(
                absorbing: isLoading,
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomerTopBar(
                        title: l10n.addCustomer,
                        onBack: () => Navigator.pop(context),
                      ).animate().fade(duration: 250.ms).slideY(begin: -.08),

                      const SizedBox(height: 18),

                      CustomerHeroIntroCard(
                        title: 'Create New Customer',
                        subtitle:
                            'Add customer details and prepare them for sales operations.',
                        selectedType: _selectedCustomerType,
                      ).animate().fade(delay: 80.ms).slideY(begin: .08),

                      const SizedBox(height: 18),

                      Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              color: isDark ? _cardDark : Colors.white,
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: .08)
                                    : Colors.black12,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                  color: Colors.black.withValues(
                                    alpha: isDark ? .18 : .06,
                                  ),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomerPremiumTextField(
                                        controller: _customerNameController,
                                        focusNode: _nameFocus,
                                        nextFocusNode: _emailFocus,
                                        label: l10n.customerName,
                                        hint: l10n.enterCustomerName,
                                        icon: Icons.person_outline_rounded,
                                        textInputAction: TextInputAction.next,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return l10n.customerNameIsRequired;
                                          }
                                          if (value.trim().length < 2) {
                                            return l10n
                                                .customerNameMustBeAtLeast2Characters;
                                          }
                                          return null;
                                        },
                                      )
                                      .animate()
                                      .fade(delay: 160.ms)
                                      .slideY(begin: .08),

                                  const SizedBox(height: 16),

                                  CustomerPremiumTextField(
                                        controller: emailController,
                                        focusNode: _emailFocus,
                                        label: l10n.email,
                                        hint: l10n.enterCustomerEmail,
                                        icon: Icons.alternate_email_rounded,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.done,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return l10n.emailIsRequired;
                                          }
                                          final emailRegex = RegExp(
                                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                          );
                                          if (!emailRegex.hasMatch(
                                            value.trim(),
                                          )) {
                                            return l10n.enterValidEmail;
                                          }
                                          return null;
                                        },
                                      )
                                      .animate()
                                      .fade(delay: 220.ms)
                                      .slideY(begin: .08),

                                  const SizedBox(height: 16),

                                  CustomerTypeSelector(
                                        selectedType: _selectedCustomerType,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedCustomerType = value;
                                          });
                                        },
                                      )
                                      .animate()
                                      .fade(delay: 280.ms)
                                      .slideY(begin: .08),

                                  const SizedBox(height: 22),

                                  AppActionButton(
                                        onPressed: () =>
                                            _handleCreateCustomer(context),
                                        label: l10n.createCustomerButton,
                                        isLoading: isLoading,
                                      )
                                      .animate()
                                      .fade(delay: 340.ms)
                                      .slideY(begin: .08),
                                ],
                              ),
                            ),
                          )
                          .animate()
                          .fade(delay: 120.ms)
                          .scale(
                            begin: const Offset(.98, .98),
                            duration: 280.ms,
                          ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
