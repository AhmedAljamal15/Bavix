import 'package:erp_sales/core/constants/app_constants.dart';
import 'package:erp_sales/core/widgets/premium_widgets.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Recent activity list section shown at the bottom of the dashboard.
class DashboardRecentActivity extends StatelessWidget {
  final AppLocalizations l10n;

  const DashboardRecentActivity({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: AppTypography.title2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'View All',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Gap(AppSpacing.lg),
        PremiumCard(
          padding: EdgeInsets.zero,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                  ),
                  const Gap(AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #SO-${2024001 + index}',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Gap(AppSpacing.xs),
                        Text(
                          'Sales order created',
                          style: AppTypography.captionSmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '2h ago',
                    style: AppTypography.captionSmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
