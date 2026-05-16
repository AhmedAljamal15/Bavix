import 'package:erp_sales/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/core/widgets/premium_widgets.dart';
import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_orders_list_repository.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:erp_sales/core/constants/app_constants.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/dashboard_kpi_section.dart';
import '../widgets/dashboard_loading_view.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_recent_activity.dart';
import '../widgets/dashboard_welcome_card.dart';

/// Premium Dashboard Screen
class DashboardScreen extends StatelessWidget {
  final AuthRepository authRepository;
  final CustomersRepository customersRepository;
  final ItemsRepository itemsRepository;
  final SalesOrdersListRepository salesOrdersListRepository;

  const DashboardScreen({
    super.key,
    required this.authRepository,
    required this.customersRepository,
    required this.itemsRepository,
    required this.salesOrdersListRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(
        authRepository: authRepository,
        customersRepository: customersRepository,
        itemsRepository: itemsRepository,
        salesOrdersListRepository: salesOrdersListRepository,
      )..loadDashboard(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: DashboardAppBar(l10n: l10n),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const DashboardLoadingView();
          }

          if (state is DashboardLoaded) {
            return _buildLoadedState(context, state, l10n);
          }

          if (state is DashboardError) {
            return ErrorStateWidget(
              message: 'Failed to load dashboard',
              errorDetails: state.message,
              onRetry: () => context.read<DashboardCubit>().loadDashboard(),
            );
          }

          return const SizedBox.expand();
        },
      ),
    );
  }

  Widget _buildLoadedState(
    BuildContext context,
    DashboardLoaded state,
    AppLocalizations l10n,
  ) {
    return RefreshIndicator(
      onRefresh: () => context.read<DashboardCubit>().refresh(),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                DashboardWelcomeCard(
                  welcomeMessage: state.welcomeMessage,
                  l10n: l10n,
                ),
                const Gap(AppSpacing.xl),

                DashboardKpiSection(state: state, l10n: l10n),
                const Gap(AppSpacing.xl),

                DashboardQuickActions(l10n: l10n),
                const Gap(AppSpacing.xl),

                DashboardRecentActivity(l10n: l10n),
                const Gap(AppSpacing.xxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
