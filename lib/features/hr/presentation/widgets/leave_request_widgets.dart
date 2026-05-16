import 'package:erp_sales/features/hr/data/models/leave_request_model.dart';
import 'package:erp_sales/features/hr/presentation/widgets/attendance_widgets.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LeaveHeroHeader extends StatelessWidget {
  final int total;
  final VoidCallback onBack;
  const LeaveHeroHeader({super.key, required this.total, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 44, 18, 34),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF020617), const Color(0xFF0B2B3D), const Color(0xFF101A35)]
              : [const Color(0xFFEFF6FF), Colors.white],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: isDark ? Colors.white : const Color(0xFF111827)),
              ),
              const Icon(Icons.event_note_outlined, color: Color(0xFF60A5FA)),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Leave Requests',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        fontSize: 24,
                        fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 28),
          Text('Leave Management',
              style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  fontSize: 30,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Text(
            'Review employee leave requests, approve pending cases and track HR workload.',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 14, height: 1.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFF60A5FA).withValues(alpha: .14),
            ),
            child: Text('$total requests loaded',
                style: const TextStyle(color: Color(0xFF60A5FA), fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequestModel request;
  final Color statusColor;
  final bool isActionLoading;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const LeaveRequestCard({
    super.key,
    required this.request,
    required this.statusColor,
    required this.isActionLoading,
    required this.onApprove,
    required this.onReject,
  });

  bool get _canTakeAction => request.status == 'Open' || request.status == 'Pending';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final employeeName = request.employeeName.isEmpty ? request.employee : request.employeeName;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(color: statusColor.withValues(alpha: .22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: statusColor.withValues(alpha: .14),
                child: Text(
                  employeeName.isEmpty ? 'E' : employeeName[0].toUpperCase(),
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(employeeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF111827),
                            fontSize: 16,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(request.name,
                        style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black54, fontSize: 12)),
                  ],
                ),
              ),
              HrStatusBadge(label: request.status, color: statusColor),
            ],
          ),
          const SizedBox(height: 16),
          HrInfoLine(icon: Icons.category_outlined, label: 'Leave Type',
              value: request.leaveType, accentColor: const Color(0xFF60A5FA)),
          const SizedBox(height: 8),
          HrInfoLine(icon: Icons.date_range_outlined, label: 'From',
              value: request.fromDate, accentColor: const Color(0xFF60A5FA)),
          const SizedBox(height: 8),
          HrInfoLine(icon: Icons.event_available_outlined, label: 'To',
              value: request.toDate, accentColor: const Color(0xFF60A5FA)),
          if (request.reason != null && request.reason!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            HrInfoLine(icon: Icons.notes_outlined, label: 'Reason',
                value: request.reason!, accentColor: const Color(0xFF60A5FA)),
          ],
          if (_canTakeAction) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isActionLoading ? null : onReject,
                    icon: const Icon(Icons.close_rounded),
                    label: Text(l10n.reject),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isActionLoading ? null : onApprove,
                    icon: const Icon(Icons.check_rounded),
                    label: Text(l10n.approve),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class LeaveEmptyState extends StatelessWidget {
  const LeaveEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
      ),
      child: Column(
        children: [
          const Icon(Icons.event_busy_outlined, size: 58, color: Color(0xFF60A5FA)),
          const SizedBox(height: 14),
          Text('No leave requests found',
              style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('Create a new request or change your filter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Shared stat card used in both attendance and leave screens.
class HrListStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const HrListStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 116,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(color: color.withValues(alpha: .22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  fontSize: 24, fontWeight: FontWeight.w900)),
          Text(title,
              style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
