import 'package:erp_sales/core/helpers/app_toast.dart';
import 'package:erp_sales/features/hr/data/models/leave_request_model.dart';
import 'package:erp_sales/features/hr/data/repo/leave_requests_repository.dart';
import 'package:erp_sales/features/hr/presentation/screens/create_leave_request_screen.dart';
import 'package:erp_sales/features/hr/presentation/widgets/attendance_widgets.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_stats_grid.dart';
import 'package:erp_sales/features/hr/presentation/widgets/leave_request_widgets.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveRequestsScreen extends StatefulWidget {
  const LeaveRequestsScreen({super.key});

  @override
  State<LeaveRequestsScreen> createState() => _LeaveRequestsScreenState();
}

class _LeaveRequestsScreenState extends State<LeaveRequestsScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;
  bool isActionLoading = false;
  String? errorMessage;
  String _query = '';
  String _filter = 'All';

  List<LeaveRequestModel> leaveRequests = [];

  @override
  void initState() {
    super.initState();
    loadLeaveRequests();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadLeaveRequests() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final repository = context.read<LeaveRequestsRepository>();
      final result = await repository.getLeaveRequests();
      if (!mounted) return;
      setState(() {
        leaveRequests = result;
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

  List<LeaveRequestModel> get filteredRequests {
    return leaveRequests.where((request) {
      final q = _query.toLowerCase().trim();
      final matchesSearch = q.isEmpty ||
          request.name.toLowerCase().contains(q) ||
          request.employee.toLowerCase().contains(q) ||
          request.employeeName.toLowerCase().contains(q) ||
          request.leaveType.toLowerCase().contains(q) ||
          request.status.toLowerCase().contains(q);
      final matchesFilter = _filter == 'All' || request.status == _filter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return const Color(0xFF2ECC71);
      case 'Rejected':
        return const Color(0xFFE74C3C);
      case 'Open':
      case 'Pending':
        return const Color(0xFFF39C12);
      default:
        return const Color(0xFF60A5FA);
    }
  }

  Future<void> _updateStatus({required LeaveRequestModel request, required String status}) async {
    if (isActionLoading) return;
    setState(() => isActionLoading = true);

    try {
      final repository = context.read<LeaveRequestsRepository>();
      await repository.updateLeaveRequestStatus(
          leaveRequestName: request.name, status: status);
      if (!mounted) return;
      AppToast.success('Leave request $status successfully');
      await loadLeaveRequests();
    } catch (e) {
      if (!mounted) return;
      AppToast.error(e.toString());
    } finally {
      if (mounted) setState(() => isActionLoading = false);
    }
  }

  Future<void> _openCreateLeaveRequest() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CreateLeaveRequestScreen()),
    );
    if (created == true && mounted) loadLeaveRequests();
  }

  @override
  Widget build(BuildContext context) {
    final approved = leaveRequests.where((e) => e.status == 'Approved').length;
    final rejected = leaveRequests.where((e) => e.status == 'Rejected').length;
    final pending = leaveRequests
        .where((e) => e.status == 'Open' || e.status == 'Pending').length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateLeaveRequest,
        icon: const Icon(Icons.add_rounded),
        label: Text(AppLocalizations.of(context)!.newRequest),
      ),
      body: RefreshIndicator(
        onRefresh: loadLeaveRequests,
        child: _buildBody(approved: approved, rejected: rejected, pending: pending),
      ),
    );
  }

  Widget _buildBody({required int approved, required int rejected, required int pending}) {
    if (isLoading) {
      return ListView(
        padding: const EdgeInsets.all(18),
        children: const [SizedBox(height: 120), Center(child: CircularProgressIndicator())],
      );
    }

    if (errorMessage != null) {
      return HrErrorView(message: errorMessage!, onRetry: loadLeaveRequests);
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        LeaveHeroHeader(
          total: leaveRequests.length,
          onBack: () => Navigator.pop(context),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 90),
          child: Column(
            children: [
              HrStatsGrid(
                children: [
                  HrListStatCard(title: 'Total', value: leaveRequests.length.toString(),
                      icon: Icons.event_note_outlined, color: const Color(0xFF60A5FA)),
                  HrListStatCard(title: 'Pending', value: pending.toString(),
                      icon: Icons.pending_actions_outlined, color: const Color(0xFFF39C12)),
                  HrListStatCard(title: 'Approved', value: approved.toString(),
                      icon: Icons.check_circle_outline, color: const Color(0xFF2ECC71)),
                  HrListStatCard(title: 'Rejected', value: rejected.toString(),
                      icon: Icons.cancel_outlined, color: const Color(0xFFE74C3C)),
                ],
              ),
              const SizedBox(height: 18),
              HrSearchFilter(
                controller: _searchController,
                selectedFilter: _filter,
                onSearch: (v) => setState(() => _query = v),
                onClear: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
                onFilterChanged: (v) => setState(() => _filter = v),
                filterLabels: const ['All', 'Open', 'Pending', 'Approved', 'Rejected'],
                hintText: 'Search leave requests...',
                accentColor: const Color(0xFF60A5FA),
              ),
              const SizedBox(height: 20),
              if (filteredRequests.isEmpty)
                const LeaveEmptyState()
              else
                Column(
                  children: filteredRequests.map((request) => LeaveRequestCard(
                    request: request,
                    statusColor: _statusColor(request.status),
                    isActionLoading: isActionLoading,
                    onApprove: () => _updateStatus(request: request, status: 'Approved'),
                    onReject: () => _updateStatus(request: request, status: 'Rejected'),
                  )).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}