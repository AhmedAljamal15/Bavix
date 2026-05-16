import 'dart:ui';

import 'package:erp_sales/core/language/cubit/language_cubit.dart';
import 'package:erp_sales/core/theme/theme_cubit.dart';
import 'package:erp_sales/core/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:erp_sales/core/widgets/premium_widgets.dart';
import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  final AuthRepository authRepository;

  const ProfileScreen({super.key, required this.authRepository});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = '';
  String role = '';
  bool isLoading = true;
  String fullName = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await widget.authRepository.getCurrentUser();

    if (!mounted) return;

    setState(() {
      fullName = user?.fullName ?? 'User';
      email = user?.email ?? 'Unknown';
      role = user?.appRole.name.toUpperCase() ?? 'USER';
      isLoading = false;
    });
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LogoutDialog(),
    );

    if (confirmed != true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LogoutLoadingDialog(),
    );

    await Future.delayed(const Duration(milliseconds: 700));
    await widget.authRepository.logout();

    if (!mounted) return;

    Navigator.pop(context);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(authRepository: widget.authRepository),
      ),
      (_) => false,
    );
  }

  void _showThemeSheet(BuildContext context) {
    final currentMode = context.read<ThemeCubit>().state.themeMode;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetHeader(
                  icon: Icons.palette_rounded,
                  title: 'Choose Appearance',
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 18),
                _ThemeOptionCard(
                  icon: Icons.phone_android_rounded,
                  title: 'System',
                  subtitle: 'Follow device theme',
                  selected: currentMode == ThemeMode.system,
                  color: const Color(0xFF60A5FA),
                  onTap: () {
                    context.read<ThemeCubit>().changeTheme(ThemeMode.system);
                    Navigator.pop(context);
                  },
                ),
                _ThemeOptionCard(
                  icon: Icons.light_mode_rounded,
                  title: 'Light Mode',
                  subtitle: 'Clean bright interface',
                  selected: currentMode == ThemeMode.light,
                  color: const Color(0xFFF59E0B),
                  onTap: () {
                    context.read<ThemeCubit>().changeTheme(ThemeMode.light);
                    Navigator.pop(context);
                  },
                ),
                _ThemeOptionCard(
                  icon: Icons.dark_mode_rounded,
                  title: 'Dark Mode',
                  subtitle: 'Premium dark ERP look',
                  selected: currentMode == ThemeMode.dark,
                  color: const Color(0xFF7C3AED),
                  onTap: () {
                    context.read<ThemeCubit>().changeTheme(ThemeMode.dark);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageSheet(BuildContext context) {
    final currentLocale = context.read<LanguageCubit>().state.locale;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetHeader(
                  icon: Icons.language_rounded,
                  title: 'Choose Language',
                  color: const Color(0xFF60A5FA),
                ),
                const SizedBox(height: 18),
                _LanguageOptionCard(
                  title: 'English',
                  subtitle: 'Use the app in English',
                  flag: '🇬🇧',
                  selected: currentLocale.languageCode == 'en',
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage(
                      const Locale('en'),
                    );
                    Navigator.pop(context);
                  },
                ),
                _LanguageOptionCard(
                  title: 'العربية',
                  subtitle: 'استخدم التطبيق باللغة العربية',
                  flag: '🇪🇬',
                  selected: currentLocale.languageCode == 'ar',
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage(
                      const Locale('ar'),
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showHelpCenterSheet(BuildContext context) {
    _showInfoSheet(
      context,
      title: 'Help Center',
      icon: Icons.support_agent_outlined,
      items: const [
        _SheetInfoItem(
          Icons.help_outline,
          'FAQ',
          'Find answers to common questions',
        ),
        _SheetInfoItem(
          Icons.bug_report_outlined,
          'Report a Problem',
          'Tell us about an issue',
        ),
        _SheetInfoItem(
          Icons.email_outlined,
          'Email Support',
          'ahmed.gadaljamal@gmail.com',
        ),
        _SheetInfoItem(
          Icons.chat_outlined,
          'Contact Us',
          '+201552582516 . Call + WhatsApp',
        ),
      ],
    );
  }

  void _showPrivacySheet(BuildContext context) {
    _showInfoSheet(
      context,
      title: 'Privacy Rights',
      icon: Icons.verified_user_outlined,
      items: const [
        _SheetInfoItem(
          Icons.privacy_tip_outlined,
          'Privacy Policy',
          'Your data is protected securely',
        ),
        _SheetInfoItem(
          Icons.description_outlined,
          'Terms of Use',
          'Read app usage terms',
        ),
        _SheetInfoItem(
          Icons.security_outlined,
          'Data Protection',
          'Enterprise-grade security',
        ),
        _SheetInfoItem(
          Icons.copyright_outlined,
          'Copyright',
          '© 2026 All Rights Reserved',
        ),
      ],
    );
  }

  void _showInfoSheet(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<_SheetInfoItem> items,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetHeader(
                  icon: icon,
                  title: title,
                  color: const Color(0xFF60A5FA),
                ),
                const SizedBox(height: 18),
                ...items.map((item) => _SheetInfoCard(item: item)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 21,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
        children: [
          _ProfileHeroCard(fullName: fullName, email: email, role: role),
          const SizedBox(height: 20),
          _ProfileTile(
            icon: Icons.person_outline_rounded,
            title: 'Account',
            subtitle: email,
            color: const Color(0xFF3B82F6),
          ),
          _ProfileTile(
            icon: Icons.badge_outlined,
            title: 'Role',
            subtitle: role,
            color: const Color(0xFF8B5CF6),
          ),
          _ProfileTile(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: Localizations.localeOf(context).languageCode == 'ar'
                ? 'العربية'
                : 'English',
            color: const Color(0xFF06B6D4),
            onTap: () => _showLanguageSheet(context),
          ),
          _ProfileTile(
            icon: Icons.palette_outlined,
            title: 'Appearance',
            subtitle: isDark ? 'Dark Mode' : 'Light Mode',
            color: const Color(0xFFF59E0B),
            onTap: () => _showThemeSheet(context),
          ),
          _ProfileTile(
            icon: Icons.support_agent_outlined,
            title: 'Help Center',
            subtitle: 'Support, FAQ & contact',
            color: const Color(0xFF22C55E),
            onTap: () => _showHelpCenterSheet(context),
          ),
          _ProfileTile(
            icon: Icons.verified_user_outlined,
            title: 'Privacy Rights',
            subtitle: 'Terms, privacy & copyright',
            color: const Color(0xFFEF4444),
            onTap: () => _showPrivacySheet(context),
          ),
          const SizedBox(height: 8),
          PremiumButton(
            label: 'Logout',
            onPressed: _logout,
            leadingIcon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(height: 26),
          Center(
            child: Column(
              children: [
                Text(
                  '© 2026 All Rights Reserved',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Developed by Ahmed Gad Elgamal',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  final String fullName;
  final String email;
  final String role;

  const _ProfileHeroCard({
    required this.fullName,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF0F172A),
                      const Color(0xFF111B3A),
                      const Color(0xFF020617),
                    ]
                  : [Colors.white, const Color(0xFFEAF2FF)],
            ),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: .08)
                  : Colors.black.withValues(alpha: .04),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 32,
                offset: const Offset(0, 14),
                color: Colors.black.withValues(alpha: isDark ? .28 : .08),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 98,
                width: 98,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      primary,
                      const Color(0xFF2563EB),
                      const Color(0xFF7C3AED),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 28,
                      spreadRadius: 2,
                      color: primary.withValues(alpha: .35),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    email.isNotEmpty ? email[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                fullName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                email,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: primary.withValues(alpha: .12),
                  border: Border.all(color: primary.withValues(alpha: .18)),
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: isDark ? const Color(0xFF101A35) : Colors.white,
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: .07)
                    : Colors.black.withValues(alpha: .04),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 9),
                  color: Colors.black.withValues(alpha: isDark ? .18 : .05),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: color.withValues(alpha: .12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SheetHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 58,
          width: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color.withValues(alpha: .14),
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _SheetInfoCard extends StatelessWidget {
  final _SheetInfoItem item;

  const _SheetInfoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const color = Color(0xFF60A5FA);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: isDark ? .16 : .05),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(item.icon, color: color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: isDark ? const Color(0xFF101A35) : Colors.white,
            border: Border.all(
              color: selected ? color : Colors.transparent,
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 8),
                color: Colors.black.withValues(alpha: isDark ? .18 : .05),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: color.withValues(alpha: .14),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected) Icon(Icons.check_circle_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String flag;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOptionCard({
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const color = Color(0xFF60A5FA);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: isDark ? const Color(0xFF101A35) : Colors.white,
            border: Border.all(
              color: selected ? color : Colors.transparent,
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 8),
                color: Colors.black.withValues(alpha: isDark ? .18 : .05),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetInfoItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SheetInfoItem(this.icon, this.title, this.subtitle);
}
