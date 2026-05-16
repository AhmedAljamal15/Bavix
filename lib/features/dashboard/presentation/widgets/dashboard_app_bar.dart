import 'package:erp_sales/core/constants/app_constants.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppLocalizations l10n;

  const DashboardAppBar({super.key, required this.l10n});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        l10n.erpSalesDashboard,
        style: AppTypography.title1.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.lg),
          child: GestureDetector(
            onTap: () {
              // Navigate to profile
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline),
            ),
          ),
        ),
      ],
    );
  }
}
