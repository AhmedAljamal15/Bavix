import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:erp_sales/core/widgets/premium_widgets.dart';
import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/features/auth/presentation/screens/login_screen.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:erp_sales/core/helpers/app_toast.dart';

class CustomerRegisterScreen extends StatefulWidget {
  final AuthRepository authRepository;

  const CustomerRegisterScreen({
    super.key,
    required this.authRepository,
  });

  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await widget.authRepository.customerRegister(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      AppToast.success(AppLocalizations.of(context)!.registrationSuccessful);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(authRepository: widget.authRepository),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      AppToast.error(e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF020617) : const Color(0xFFEFF6FF),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF020617),
                    Color(0xFF0B1228),
                    Color(0xFF101A35),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFEFF6FF),
                    Color(0xFFF8FBFF),
                    Colors.white,
                  ],
                ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
            children: [
              _RegisterTopBar(
                title: l10n.createCustomerAccountTitle,
                isDark: isDark,
                onBack: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
              _RegisterCard(
                isDark: isDark,
                formKey: _formKey,
                fullNameController: fullNameController,
                emailController: emailController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController,
                obscurePassword: obscurePassword,
                obscureConfirmPassword: obscureConfirmPassword,
                onTogglePassword: () {
                  setState(() => obscurePassword = !obscurePassword);
                },
                onToggleConfirmPassword: () {
                  setState(
                    () => obscureConfirmPassword = !obscureConfirmPassword,
                  );
                },
                isLoading: isLoading,
                onRegister: register,
                l10n: l10n,
              ),
              const SizedBox(height: 14),
              Text(
                l10n.afterRegistrationCheckYourEmailToCompleteAccountSetup,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterTopBar extends StatelessWidget {
  final String title;
  final bool isDark;
  final VoidCallback onBack;

  const _RegisterTopBar({
    required this.title,
    required this.isDark,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _RegisterCard extends StatelessWidget {
  final bool isDark;
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final bool isLoading;
  final VoidCallback onRegister;
  final AppLocalizations l10n;

  const _RegisterCard({
    required this.isDark,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.isLoading,
    required this.onRegister,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 16),
            color: Colors.black.withValues(alpha: isDark ? .24 : .08),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Lottie.asset(
                'assets/lottie/login_security.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
            const SizedBox(height: 8),
            _RegisterField(
              controller: fullNameController,
              label: l10n.fullName,
              icon: Icons.person_outline_rounded,
              isDark: isDark,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.fullNameIsRequired;
                }
                if (value.trim().length < 2) {
                  return l10n.enterValidFullName;
                }
                return null;
              },
            ),
            const SizedBox(height: 13),
            _RegisterField(
              controller: emailController,
              label: l10n.email,
              icon: Icons.email_outlined,
              isDark: isDark,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.emailIsRequired;
                }

                final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return l10n.enterValidEmail;
                }

                return null;
              },
            ),
            const SizedBox(height: 13),
            _RegisterField(
              controller: passwordController,
              label: l10n.password,
              icon: Icons.lock_outline_rounded,
              isDark: isDark,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: isDark ? Colors.white60 : Colors.black45,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.passwordIsRequired;
                }
                if (value.length < 6) {
                  return l10n.passwordMustBeAtLeast6Characters;
                }
                return null;
              },
            ),
            const SizedBox(height: 13),
            _RegisterField(
              controller: confirmPasswordController,
              label: l10n.pleaseConfirmPassword,
              icon: Icons.lock_person_outlined,
              isDark: isDark,
              obscureText: obscureConfirmPassword,
              suffixIcon: IconButton(
                onPressed: onToggleConfirmPassword,
                icon: Icon(
                  obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: isDark ? Colors.white60 : Colors.black45,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseConfirmPassword;
                }
                if (value != passwordController.text) {
                  return l10n.passwordsDoNotMatch;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: PremiumButton(
                label: l10n.createAccount,
                isLoading: isLoading,
                onPressed: onRegister,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isDark;
  final String? Function(String?) validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const _RegisterField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    required this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF111827),
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.white54 : const Color(0xFF64748B),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF60A5FA),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? const Color(0xFF0B1228) : const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: const Color(0xFF60A5FA).withValues(alpha: .18),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: const Color(0xFF60A5FA).withValues(alpha: .18),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF60A5FA),
            width: 1.4,
          ),
        ),
      ),
    );
  }
}