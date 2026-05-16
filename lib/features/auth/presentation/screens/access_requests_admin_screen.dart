import 'package:erp_sales/features/auth/presentation/widgets/access_request_card.dart';
import 'package:erp_sales/features/auth/presentation/widgets/empty_state.dart';
import 'package:erp_sales/features/auth/presentation/widgets/search_filter_box.dart';
import 'package:erp_sales/features/auth/presentation/widgets/stats_row.dart';
import 'package:erp_sales/features/auth/presentation/widgets/top_bar.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/auth/data/models/access_request_item_model.dart';
import 'package:erp_sales/features/auth/data/repo/access_request_admin_repository.dart';
import 'package:erp_sales/core/helpers/app_toast.dart';

class AccessRequestsAdminScreen extends StatefulWidget {
  const AccessRequestsAdminScreen({super.key});

  @override
  State<AccessRequestsAdminScreen> createState() =>
      _AccessRequestsAdminScreenState();
}

class _AccessRequestsAdminScreenState extends State<AccessRequestsAdminScreen> {
  bool isLoading = true;
  String? updatingId;
  String? errorMessage;

  List<AccessRequestItemModel> requests = [];

  final TextEditingController searchController = TextEditingController();
  String query = '';
  String selectedStatus = 'Pending';

  static const Color primary = Color(0xFF60A5FA);
  static const Color bgDark = Color(0xFF020617);
  static const Color cardDark = Color(0xFF101A35);

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadRequests() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final repository = context.read<AccessRequestAdminRepository>();
      final result = await repository.getAccessRequests();

      if (!mounted) return;

      setState(() {
        requests = result;
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

  String displayStatus(String status) {
    switch (status) {
      case 'Open':
        return 'Pending';
      case 'Interested':
        return 'Approved';
      case 'Do Not Contact':
        return 'Rejected';
      default:
        return status;
    }
  }

  String erpStatusFromDisplay(String status) {
    switch (status) {
      case 'Pending':
        return 'Open';
      case 'Approved':
        return 'Interested';
      case 'Rejected':
        return 'Do Not Contact';
      default:
        return 'All';
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'Open':
        return const Color(0xFFF59E0B);
      case 'Interested':
        return const Color(0xFF22C55E);
      case 'Do Not Contact':
        return const Color(0xFFEF4444);
      default:
        return primary;
    }
  }

  List<AccessRequestItemModel> get filteredRequests {
    return requests.where((request) {
      final text =
          '${request.fullName} ${request.email} ${request.status} ${request.owner}'
              .toLowerCase();

      final matchesSearch = text.contains(query);

      final requiredStatus = erpStatusFromDisplay(selectedStatus);
      final matchesStatus =
          selectedStatus == 'All' || request.status == requiredStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> approveRequest(String requestId) async {
    setState(() => updatingId = requestId);

    try {
      final repository = context.read<AccessRequestAdminRepository>();
      await repository.approveRequest(requestId);

      if (!mounted) return;

      AppToast.success('Request approved successfully');
      await loadRequests();
    } catch (e) {
      if (!mounted) return;
      AppToast.error(e.toString());
    } finally {
      if (mounted) setState(() => updatingId = null);
    }
  }

  Future<void> rejectRequest(String requestId) async {
    setState(() => updatingId = requestId);

    try {
      final repository = context.read<AccessRequestAdminRepository>();
      await repository.rejectRequest(requestId);

      if (!mounted) return;

      AppToast.success('Request rejected successfully');
      await loadRequests();
    } catch (e) {
      if (!mounted) return;
      AppToast.error(e.toString());
    } finally {
      if (mounted) setState(() => updatingId = null);
    }
  }

  void openStatusFilter() {
    final statuses = ['All', 'Pending', 'Approved', 'Rejected'];

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Filter access requests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                ...statuses.map((status) {
                  final selected = selectedStatus == status;

                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    leading: Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selected ? primary : Colors.grey,
                    ),
                    title: Text(
                      status,
                      style: TextStyle(
                        fontWeight:
                            selected ? FontWeight.w900 : FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      setState(() => selectedStatus = status);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = filteredRequests;

    return Scaffold(
      backgroundColor:
          isDark ? bgDark : Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              title: 'Access Requests',
              onBack: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
              child: SearchFilterBox(
                controller: searchController,
                selectedStatus: selectedStatus,
                onChanged: (value) {
                  setState(() => query = value.trim().toLowerCase());
                },
                onFilterTap: openStatusFilter,
                onClearFilter: () {
                  setState(() => selectedStatus = 'All');
                },
              ),
            ),
            StatsRow(
              total: requests.length,
              pending:
                  requests.where((e) => e.status == 'Open').length,
              approved:
                  requests.where((e) => e.status == 'Interested').length,
              rejected: requests
                  .where((e) => e.status == 'Do Not Contact')
                  .length,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: loadRequests,
                child: buildBody(items),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody(List<AccessRequestItemModel> items) {
    if (isLoading) {
      return  ListView(
        children: [
          SizedBox(height: 220),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (errorMessage != null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 100),
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Color(0xFFEF4444),
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: loadRequests,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      );
    }

    if (items.isEmpty) {
      return EmptyState(
        title: selectedStatus == 'Pending'
            ? 'No pending access requests'
            : 'No access requests found',
        subtitle: query.isEmpty
            ? 'New access requests will appear here.'
            : 'Try another search keyword.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 26),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final request = items[index];
        final color = statusColor(request.status);
        final isUpdating = updatingId == request.id;
        final isPending = request.status == 'Open';

        return AccessRequestCard(
          request: request,
          statusText: displayStatus(request.status),
          statusColor: color,
          isUpdating: isUpdating,
          showActions: isPending,
          onApprove: () => approveRequest(request.id),
          onReject: () => rejectRequest(request.id),
        );
      },
    );
  }
}

















