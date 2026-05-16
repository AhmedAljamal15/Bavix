import 'package:erp_sales/features/hr/data/models/attendance_model.dart';
import 'package:erp_sales/features/hr/data/repo/attendance_repository.dart';
import 'package:erp_sales/features/hr/presentation/screens/create_attendance_screen.dart';
import 'package:erp_sales/features/hr/presentation/widgets/attendance_widgets.dart';
import 'package:erp_sales/features/hr/presentation/widgets/hr_stats_grid.dart';
import 'package:erp_sales/features/hr/presentation/widgets/leave_request_widgets.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;
  String? errorMessage;
  String _query = '';
  String _filter = 'All';

  List<AttendanceModel> attendance = [];

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadAttendance() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final repository = context.read<AttendanceRepository>();
      final result = await repository.getAttendance();
      if (!mounted) return;
      setState(() {
        attendance = result;
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

  List<AttendanceModel> get filteredAttendance {
    return attendance.where((item) {
      final q = _query.toLowerCase().trim();
      final matchesSearch = q.isEmpty ||
          item.name.toLowerCase().contains(q) ||
          item.employee.toLowerCase().contains(q) ||
          item.employeeName.toLowerCase().contains(q) ||
          item.status.toLowerCase().contains(q) ||
          item.attendanceDate.toLowerCase().contains(q);
      final matchesFilter = _filter == 'All' || item.status == _filter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Present':
        return const Color(0xFF2ECC71);
      case 'Absent':
        return const Color(0xFFE74C3C);
      case 'Half Day':
        return const Color(0xFFF39C12);
      case 'On Leave':
        return const Color(0xFF60A5FA);
      default:
        return const Color(0xFF9B59B6);
    }
  }

  Future<void> _openCreateAttendance() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CreateAttendanceScreen()),
    );
    if (created == true && mounted) loadAttendance();
  }

  @override
  Widget build(BuildContext context) {
    final present = attendance.where((e) => e.status == 'Present').length;
    final absent = attendance.where((e) => e.status == 'Absent').length;
    final halfDay = attendance.where((e) => e.status == 'Half Day').length;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateAttendance,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.newAttendance),
      ),
      body: RefreshIndicator(
        onRefresh: loadAttendance,
        child: _buildBody(present: present, absent: absent, halfDay: halfDay),
      ),
    );
  }

  Widget _buildBody({required int present, required int absent, required int halfDay}) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return ListView(
        padding: const EdgeInsets.all(18),
        children: const [SizedBox(height: 120), Center(child: CircularProgressIndicator())],
      );
    }

    if (errorMessage != null) {
      return HrErrorView(message: errorMessage!, onRetry: loadAttendance);
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        AttendanceHeroHeader(
          total: attendance.length,
          onBack: () => Navigator.pop(context),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 90),
          child: Column(
            children: [
              HrStatsGrid(
                children: [
                  HrListStatCard(title: l10n.totalLabel, value: attendance.length.toString(),
                      icon: Icons.fact_check_outlined, color: const Color(0xFF60A5FA)),
                  HrListStatCard(title: l10n.present, value: present.toString(),
                      icon: Icons.check_circle_outline, color: const Color(0xFF2ECC71)),
                  HrListStatCard(title: l10n.absent, value: absent.toString(),
                      icon: Icons.cancel_outlined, color: const Color(0xFFE74C3C)),
                  HrListStatCard(title: l10n.halfDay, value: halfDay.toString(),
                      icon: Icons.timelapse_outlined, color: const Color(0xFFF39C12)),
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
                filterLabels: [l10n.allRoles, l10n.present, l10n.absent, l10n.halfDay, l10n.onLeave],
                hintText: l10n.searchAttendance,
                accentColor: const Color(0xFF2ECC71),
              ),
              const SizedBox(height: 20),
              if (filteredAttendance.isEmpty)
                const AttendanceEmptyState()
              else
                Column(
                  children: filteredAttendance.map((item) => AttendanceCard(
                    item: item,
                    statusColor: _statusColor(item.status),
                  )).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}