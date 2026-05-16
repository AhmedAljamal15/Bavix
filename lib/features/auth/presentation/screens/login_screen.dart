import 'package:erp_sales/features/auth/data/repo/access_request_repository.dart';
import 'package:erp_sales/core/constants/app_constants.dart';
import 'package:erp_sales/core/widgets/premium_widgets.dart';
import 'package:erp_sales/features/auth/presentation/screens/access_request_screen.dart';
import 'package:erp_sales/features/auth/presentation/screens/customer_register_screen.dart';
import 'package:erp_sales/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:erp_sales/core/helpers/app_toast.dart';

class LoginScreen extends StatefulWidget {
  final AuthRepository authRepository;

  const LoginScreen({super.key, required this.authRepository});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    emailController.text = 'nikiniw477@codoteam.com';
    passwordController.text = r'123456qQ@#$';
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      await widget.authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      AppToast.success('Welcome back ');  

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => SplashScreen(authRepository: widget.authRepository),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      AppToast.error(e.toString());
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF020617)
          : const Color(0xFFEFF6FF),
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
                  colors: [Color(0xFFEFF6FF), Color(0xFFF8FBFF), Colors.white],
                ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
            children: [
              const SizedBox(height: 8),
              _LoginHeader(isDark: isDark),
              const SizedBox(height: 18),
              Form(
                key: _formKey,
                child: _LoginCard(
                  isDark: isDark,
                  emailController: emailController,
                  passwordController: passwordController,
                  obscurePassword: obscurePassword,
                  onTogglePassword: () {
                    setState(() => obscurePassword = !obscurePassword);
                  },
                  isLoading: isLoading,
                  onLogin: login,
                  signInLabel: l10n.signIn,
                  emailLabel: l10n.email,
                  passwordLabel: l10n.password,
                ),
              ),
              const SizedBox(height: 18),
              _ActionPanel(
                isDark: isDark,
                requestAccessLabel: l10n.requestAccessButton,
                createAccountLabel: l10n.createCustomerAccount,
                onRequestAccess: () async {
                  final accessRequestRepository = context
                      .read<AccessRequestRepository>();

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AccessRequestScreen(
                        accessRequestRepository: accessRequestRepository,
                      ),
                    ),
                  );
                },
                onCreateAccount: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerRegisterScreen(
                        authRepository: widget.authRepository,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  final bool isDark;

  const _LoginHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: 34,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to manage your ERP workspace.',
          style: TextStyle(
            color: isDark ? Colors.white70 : const Color(0xFF64748B),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  final bool isDark;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final bool isLoading;
  final VoidCallback onLogin;
  final String signInLabel;
  final String emailLabel;
  final String passwordLabel;

  const _LoginCard({
    required this.isDark,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.isLoading,
    required this.onLogin,
    required this.signInLabel,
    required this.emailLabel,
    required this.passwordLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
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
      child: Column(
        children: [
          SizedBox(
            height: 175,
            child: Lottie.asset(
              'assets/lottie/login_security.json',
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),
          const SizedBox(height: 8),
          _AuthTextField(
            controller: emailController,
            label: emailLabel,
            icon: Icons.email_outlined,
            isDark: isDark,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }

              final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

              if (!emailRegex.hasMatch(value.trim())) {
                return 'Enter a valid email';
              }

              return null;
            },
          ),
          const SizedBox(height: 14),
          _AuthTextField(
            controller: passwordController,
            label: passwordLabel,
            icon: Icons.lock_outline_rounded,
            isDark: isDark,
            obscureText: obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }

              if (value.length < 6) {
                return 'Minimum 6 characters';
              }

              return null;
            },
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF60A5FA),
              ),
              onPressed: onTogglePassword,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: PremiumButton(
              label: signInLabel,
              isLoading: isLoading,
              onPressed: onLogin,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPanel extends StatelessWidget {
  final bool isDark;
  final String requestAccessLabel;
  final String createAccountLabel;
  final VoidCallback onRequestAccess;
  final VoidCallback onCreateAccount;

  const _ActionPanel({
    required this.isDark,
    required this.requestAccessLabel,
    required this.createAccountLabel,
    required this.onRequestAccess,
    required this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: isDark ? .18 : .06),
          ),
        ],
      ),
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.vpn_key_outlined,
            title: requestAccessLabel,
            isDark: isDark,
            onTap: onRequestAccess,
          ),
          Divider(
            height: 1,
            color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
          ),
          _ActionTile(
            icon: Icons.person_add_alt_1_outlined,
            title: createAccountLabel,
            isDark: isDark,
            onTap: onCreateAccount,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF3B82F6).withValues(alpha: .14),
        ),
        child: Icon(icon, color: const Color(0xFF60A5FA)),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF111827),
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: isDark ? Colors.white54 : Colors.black45,
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isDark;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
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
        prefixIcon: Icon(icon, color: const Color(0xFF60A5FA)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? const Color(0xFF0B1228) : const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFE74C3C),
          fontWeight: FontWeight.w700,
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
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: Color(0xFF60A5FA), width: 1.4),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: Color(0xFFE74C3C), width: 1.2),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: Color(0xFFE74C3C), width: 1.4),
        ),
      ),
    );
  }
}
