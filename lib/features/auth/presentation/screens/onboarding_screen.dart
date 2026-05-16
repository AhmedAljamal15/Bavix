import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:erp_sales/core/constants/app_constants.dart';
import 'package:erp_sales/core/widgets/premium_widgets.dart';
import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/features/auth/presentation/screens/login_screen.dart';
import 'package:erp_sales/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  final AuthRepository authRepository;

  const OnboardingScreen({
    super.key,
    required this.authRepository,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_OnboardingData> pages = const [
    _OnboardingData(
      title: 'Manage Everything in One Place',
      subtitle: 'Users, customers, products, orders, invoices and more.',
      lottieAsset: 'assets/lottie/on_boarding1.json',
    ),
    _OnboardingData(
      title: 'Secure. Fast. Reliable',
      subtitle: 'Enterprise-grade experience built for continuous operations.',
      lottieAsset: 'assets/lottie/on_boarding2.json',
    ),
    _OnboardingData(
      title: 'Real-time Insights',
      subtitle: 'Powerful dashboards and reports to drive smarter actions.',
      lottieAsset: 'assets/lottie/on_boarding3.json',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await widget.authRepository.completeOnboarding();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          authRepository: widget.authRepository,
        ),
      ),
    );
  }

  void _next() {
    if (_index == pages.length - 1) {
      _finish();
      return;
    }

    _controller.nextPage(
      duration: AppDuration.slower,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient:
              isDark ? AppGradients.primaryGradient : AppGradients.lightHeader,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _finish,
                      child: Text(
                        'Skip',
                        style: AppTypography.labelLarge.copyWith(
                          color:
                              (isDark ? Colors.white : AppColors.textPrimary)
                                  .withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (value) {
                    setState(() => _index = value);
                  },
                  itemBuilder: (context, i) {
                    final data = pages[i];

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
                      child: GlassMorphismCard(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Lottie.asset(
                                  data.lottieAsset,
                                  fit: BoxFit.contain,
                                  repeat: true,
                                  animate: true,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data.title,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.headline3.copyWith(
                                      color: isDark
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    data.subtitle,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: (isDark
                                              ? Colors.white
                                              : AppColors.textSecondary)
                                          .withValues(alpha: 0.85),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (i) => AnimatedContainer(
                    duration: AppDuration.slow,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _index == i ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: _index == i
                          ? AppColors.electricBlue
                          : isDark
                              ? Colors.white38
                              : AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: PremiumButton(
                    label:
                        _index == pages.length - 1 ? l10n.getStarted : 'Next',
                    onPressed: _next,
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

class _OnboardingData {
  final String title;
  final String subtitle;
  final String lottieAsset;

  const _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.lottieAsset,
  });
}