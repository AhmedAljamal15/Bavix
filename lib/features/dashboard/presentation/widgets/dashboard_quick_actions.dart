import 'package:erp_sales/core/constants/app_constants.dart';
import 'package:erp_sales/core/widgets/premium_widgets.dart';
import 'package:erp_sales/core/widgets/responsive_layout.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Quick-action grid shown below the KPI cards.
class DashboardQuickActions extends StatelessWidget {
  final AppLocalizations l10n;

  const DashboardQuickActions({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTypography.title2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(AppSpacing.lg),
        ResponsiveGrid(
          mobileColumns: 2,
          tabletColumns: 3,
          desktopColumns: 4,
          children: [
            DashboardActionCard(
              icon: Icons.receipt_long_outlined,
              label: 'Orders',
              color: AppColors.secondary,
              onTap: () {},
            ),
            DashboardActionCard(
              icon: Icons.person_add_outlined,
              label: 'Customers',
              color: AppColors.success,
              onTap: () {},
            ),
            DashboardActionCard(
              icon: Icons.inventory_2_outlined,
              label: 'Items',
              color: AppColors.warning,
              onTap: () {},
            ),
            DashboardActionCard(
              icon: Icons.local_shipping_outlined,
              label: 'Delivery',
              color: AppColors.info,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

/// Individual tappable card inside [DashboardQuickActions].
class DashboardActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const DashboardActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: AppIconSize.lg),
          ),
          const Gap(AppSpacing.md),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
