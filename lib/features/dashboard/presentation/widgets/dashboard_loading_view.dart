import 'package:erp_sales/core/constants/app_constants.dart';
import 'package:erp_sales/core/widgets/premium_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Skeleton loading placeholders shown while dashboard data is fetching.
class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SkeletonLoader(height: 120),
              Gap(AppSpacing.lg),
              SkeletonLoader(height: 180),
              const Gap(AppSpacing.lg),
              SkeletonLoader(height: 220),
            ]),
          ),
        ),
      ],
    );
  }
}
