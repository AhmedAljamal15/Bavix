import 'package:erp_sales/features/ai_assistant/data/repo/ai_assistant_repository.dart';
import 'package:erp_sales/features/ai_assistant/logic/cubit/ai_assistant_cubit.dart';
import 'package:erp_sales/features/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import 'package:erp_sales/features/hr/presentation/screens/attendance_screen.dart';
import 'package:erp_sales/features/hr/presentation/screens/create_employee_screen.dart';
import 'package:erp_sales/features/hr/presentation/screens/payroll_screen.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_action_card.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_alert_card.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_hero_header.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_search_and_filter.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_section_header.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_stat_card.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_stats_grid.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_user_card.dart';
import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:erp_sales/core/widgets/premium_widgets.dart';

import 'package:erp_sales/features/auth/data/models/hr_user_model.dart';
import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/features/auth/data/repo/hr_users_repository.dart';
import 'package:erp_sales/features/auth/presentation/screens/profile_screen.dart';
import 'package:erp_sales/features/hr/presentation/screens/leave_requests_screen.dart';

class HrHomeScreen extends StatefulWidget {
  const HrHomeScreen({super.key});

  @override
  State<HrHomeScreen> createState() => _HrHomeScreenState();
}

class _HrHomeScreenState extends State<HrHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;
  String? errorMessage;
  String _query = '';
  String _filter = 'All';

  List<HrUserModel> users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final hrUsersRepository = context.read<HrUsersRepository>();
      final result = await hrUsersRepository.getUsers();

      if (!mounted) return;

      setState(() {
        users = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  List<HrUserModel> _filteredUsers() {
    return users.where((user) {
      final q = _query.toLowerCase().trim();

      final matchesSearch =
          q.isEmpty ||
          user.name.toLowerCase().contains(q) ||
          user.fullName.toLowerCase().contains(q) ||
          user.userType.toLowerCase().contains(q);

      final matchesFilter = switch (_filter) {
        'System' => user.userType == 'System User',
        'Website' => user.userType == 'Website User',
        'Enabled' => user.enabled,
        'Disabled' => !user.enabled,
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = context.read<AuthRepository>();
    final l10n = AppLocalizations.of(context)!;
    final systemUsers =
        users.where((u) => u.userType == 'System User').length;
    final websiteUsers =
        users.where((u) => u.userType == 'Website User').length;
    final enabledUsers = users.where((u) => u.enabled).length;
    final disabledUsers = users.where((u) => !u.enabled).length;

    return FutureBuilder(
      future: authRepository.getCurrentPermissions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final permissions = snapshot.data!;

        if (!permissions.canViewHrDashboard) {
          return Scaffold(
            body: Center(
              child: Text(l10n.noPermission),
            ),
          );
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) =>
                        AiAssistantCubit(context.read<AiAssistantRepository>()),
                    child: const AiAssistantScreen(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.smart_toy),
            label: const Text('AI'),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: RefreshIndicator(
            onRefresh: loadUsers,
            child: _buildBody(
              context,
              l10n: l10n,
              authRepository: authRepository,
              systemUsers: systemUsers,
              websiteUsers: websiteUsers,
              enabledUsers: enabledUsers,
              disabledUsers: disabledUsers,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required AppLocalizations l10n,
    required AuthRepository authRepository,
    required int systemUsers,
    required int websiteUsers,
    required int enabledUsers,
    required int disabledUsers,
  }) {
    if (isLoading) {
      return ListView(
        padding: const EdgeInsets.all(22),
        children: List.generate(
          5,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 14),
            child: SkeletonLoader(height: 110),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return ErrorStateWidget(message: errorMessage!, onRetry: loadUsers);
    }

    final filteredUsers = _filteredUsers();

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        HrHeroHeader(
          totalUsers: users.length,
          onBack: () => Navigator.pop(context),
          onProfile: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProfileScreen(authRepository: authRepository),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
          child: Column(
            children: [
              HrStatsGrid(
                children: [
                  HrStatCard(
                    title: 'Total Users',
                    value: users.length.toString(),
                    icon: Icons.groups_2_outlined,
                    color: const Color(0xFF42A5F5),
                  ),
                  HrStatCard(
                    title: 'Enabled',
                    value: enabledUsers.toString(),
                    icon: Icons.verified_user_outlined,
                    color: const Color(0xFF2ECC71),
                  ),
                  HrStatCard(
                    title: 'System Users',
                    value: systemUsers.toString(),
                    icon: Icons.badge_outlined,
                    color: const Color(0xFFF39C12),
                  ),
                  HrStatCard(
                    title: 'Website Users',
                    value: websiteUsers.toString(),
                    icon: Icons.language_outlined,
                    color: const Color(0xFF9B59B6),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              HrSearchAndFilter(
                controller: _searchController,
                selectedFilter: _filter,
                onSearch: (value) => setState(() => _query = value),
                onClear: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
                onFilterChanged: (value) => setState(() => _filter = value),
              ),
              const SizedBox(height: 18),
              HrSectionHeader(
                title: 'HR Alerts',
                subtitle: 'Workforce status and quick warnings',
              ),
              const SizedBox(height: 12),
              HrAlertCard(
                icon: Icons.warning_amber_rounded,
                title: '$disabledUsers disabled accounts',
                subtitle: disabledUsers == 0
                    ? 'All accounts are currently enabled.'
                    : 'Review disabled users and access status.',
                color: disabledUsers == 0
                    ? const Color(0xFF2ECC71)
                    : const Color(0xFFE74C3C),
              ),
              const SizedBox(height: 18),
              HrSectionHeader(
                title: 'Quick Actions',
                subtitle: 'Manage HR operations faster',
              ),
              const SizedBox(height: 12),
              HrStatsGrid(
                children: [
                  HrActionCard(
                    icon: Icons.event_note_outlined,
                    title: 'Leave Requests',
                    subtitle: 'Review requests',
                    color: const Color(0xFF42A5F5),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LeaveRequestsScreen(),
                      ),
                    ),
                  ),
                  HrActionCard(
                    icon: Icons.access_time_outlined,
                    title: 'Attendance',
                    subtitle: 'Track records',
                    color: const Color(0xFF2ECC71),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AttendanceScreen(),
                      ),
                    ),
                  ),
                  HrActionCard(
                    icon: Icons.payments_outlined,
                    title: 'Payroll',
                    subtitle: 'Salary slips',
                    color: const Color(0xFFF39C12),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PayrollScreen(),
                      ),
                    ),
                  ),
                  HrActionCard(
                    icon: Icons.person_add_alt_1_outlined,
                    title: 'Add Employee',
                    subtitle: 'Create employee',
                    color: const Color(0xFF9B59B6),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateEmployeeScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              HrSectionHeader(
                title: 'Workforce Directory',
                subtitle: '${filteredUsers.length} users displayed',
              ),
              const SizedBox(height: 12),
              if (filteredUsers.isEmpty)
                EmptyStateWidget(
                  icon: Icons.search_off_rounded,
                  title: l10n.hrDashboardTitle,
                )
              else
                Column(
                  children: filteredUsers
                      .map((user) => HrUserCard(user: user))
                      .toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
