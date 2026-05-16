import 'package:erp_sales/core/constants/app_constants.dart';
import 'package:erp_sales/core/widgets/premium_widgets.dart';
import 'package:erp_sales/core/widgets/responsive_layout.dart';
import 'package:erp_sales/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Responsive KPI cards row showing orders, customers, items, and revenue.
class DashboardKpiSection extends StatelessWidget {
  final DashboardLoaded state;
  final AppLocalizations l10n;

  const DashboardKpiSection({
    super.key,
    required this.state,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 4,
      children: [
        KPICard(
          title: l10n.salesOrders,
          value: state.totalSalesOrders.toString(),
          icon: Icons.shopping_cart_outlined,
          iconColor: AppColors.secondary,
          showTrend: true,
          trendValue: 12.5,
          isPositive: true,
        ).animate().fade(delay: 100.ms).slideY(begin: 0.1),
        KPICard(
          title: l10n.customers,
          value: state.totalCustomers.toString(),
          icon: Icons.people_outline,
          iconColor: AppColors.success,
          showTrend: true,
          trendValue: 8.2,
          isPositive: true,
        ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
        KPICard(
          title: l10n.items,
          value: state.totalItems.toString(),
          icon: Icons.inventory_2_outlined,
          iconColor: AppColors.warning,
          showTrend: true,
          trendValue: 3.1,
          isPositive: false,
        ).animate().fade(delay: 300.ms).slideY(begin: 0.1),
        KPICard(
          title: 'Revenue',
          value: '\$${state.totalRevenue.toStringAsFixed(0)}',
          icon: Icons.trending_up_outlined,
          iconColor: AppColors.info,
          showTrend: true,
          trendValue: 23.8,
          isPositive: true,
        ).animate().fade(delay: 400.ms).slideY(begin: 0.1),
      ],
    );
  }
}
