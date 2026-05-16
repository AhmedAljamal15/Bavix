import 'package:erp_sales/features/auth/presentation/screens/admin_home_screen.dart';
import 'package:erp_sales/features/auth/presentation/screens/customer_home_screen.dart';
import 'package:erp_sales/features/hr/presentation/screens/hr_home_screen.dart';
import 'package:erp_sales/features/auth/presentation/screens/sales_home_screen.dart';
import 'package:erp_sales/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:erp_sales/features/auth/data/models/app_user_model.dart';
import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/features/auth/presentation/screens/login_screen.dart';
import 'package:erp_sales/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:rive/rive.dart';

class SplashScreen extends StatefulWidget {
  final AuthRepository authRepository;

  const SplashScreen({super.key, required this.authRepository});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await Future.delayed(const Duration(seconds: 2));

    final onboardingSeen = await widget.authRepository.isOnboardingSeen();
    final user = await widget.authRepository.getCurrentUser();

    if (!mounted) return;

    if (!onboardingSeen) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              OnboardingScreen(authRepository: widget.authRepository),
        ),
      );
      return;
    }

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(authRepository: widget.authRepository),
        ),
      );
      return;
    }

    switch (user.appRole) {
      case AppRole.admin:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
        );
        break;

      case AppRole.sales:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SalesHomeScreen()),
        );
        break;

      case AppRole.hr:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HrHomeScreen()),
        );
        break;

      case AppRole.customer:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
        );
        break;

      case AppRole.employee:
      case AppRole.unknown:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SalesHomeScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppGradients.primaryGradient : AppGradients.lightHeader,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: const Alignment(-0.9, -0.85),
              child: _GlowOrb(
                color: AppColors.gradientGlow.withValues(alpha: 0.28),
                size: 180,
              ),
            ),
            Align(
              alignment: const Alignment(0.95, 0.95),
              child: _GlowOrb(
                color: AppColors.neonViolet.withValues(alpha: 0.2),
                size: 240,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: Column(
                  children: [
                    const Spacer(),
                    Container(
                      height: 210,
                      width: 210,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.82),
                        border: Border.all(
                          color: isDark
                              ? AppColors.neonBlue.withValues(alpha: 0.35)
                              : AppColors.primary.withValues(alpha: 0.18),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: _NetworkRiveView(
                          url: 'https://cdn.rive.app/animations/vehicles.riv',
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      l10n.appTitle,
                      style: AppTypography.headline2.copyWith(
                        color: isDark ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Enterprise intelligence for modern teams',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        color: (isDark ? Colors.white : AppColors.textPrimary)
                            .withValues(alpha: 0.78),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: const LinearProgressIndicator(minHeight: 4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Loading...',
                      style: AppTypography.caption.copyWith(
                        color: (isDark ? Colors.white : AppColors.textSecondary)
                            .withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }
}

class _NetworkRiveView extends StatefulWidget {
  final String url;

  const _NetworkRiveView({required this.url});

  @override
  State<_NetworkRiveView> createState() => _NetworkRiveViewState();
}

class _NetworkRiveViewState extends State<_NetworkRiveView> {
  late final FileLoader _loader;

  @override
  void initState() {
    super.initState();
    _loader = FileLoader.fromUrl(widget.url, riveFactory: Factory.rive);
  }

  @override
  void dispose() {
    _loader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: _loader,
      builder: (context, state) {
        return switch (state) {
          RiveLoading() => const Center(child: CircularProgressIndicator()),
          RiveFailed() => const Center(child: Icon(Icons.animation_outlined)),
          RiveLoaded() => RiveWidget(
              controller: state.controller,
              fit: Fit.cover,
            ),
        };
      },
    );
  }
}
