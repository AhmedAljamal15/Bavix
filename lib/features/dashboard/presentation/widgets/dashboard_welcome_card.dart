import 'package:erp_sales/core/constants/app_constants.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Gradient welcome banner shown at the top of the loaded dashboard.
class DashboardWelcomeCard extends StatelessWidget {
  final String welcomeMessage;
  final AppLocalizations l10n;

  const DashboardWelcomeCard({
    super.key,
    required this.welcomeMessage,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: AppRadius.borderRadiusXl,
        boxShadow: AppElevation.shadowLg,
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            welcomeMessage,
            style: AppTypography.headline2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Gap(AppSpacing.sm),
          Text(
            l10n.manageYourSalesEfficiently,
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
