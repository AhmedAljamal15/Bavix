import 'package:erp_sales/features/hr/data/models/attendance_model.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Gradient hero header for the Attendance screen.
class AttendanceHeroHeader extends StatelessWidget {
  final int total;
  final VoidCallback onBack;

  const AttendanceHeroHeader({
    super.key,
    required this.total,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 44, 18, 34),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF020617),
                  const Color(0xFF063B33),
                  const Color(0xFF101A35),
                ]
              : [const Color(0xFFF0FDF4), Colors.white],
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
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              const Icon(Icons.access_time_outlined, color: Color(0xFF2ECC71)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.attendance,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            l10n.attendanceManagement,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.trackAttendanceDescription,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFF2ECC71).withValues(alpha: .14),
            ),
            child: Text(
              l10n.attendanceRecordsLoaded(total),
              style: const TextStyle(
                color: Color(0xFF2ECC71),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card for a single attendance record.
class AttendanceCard extends StatelessWidget {
  final AttendanceModel item;
  final Color statusColor;

  const AttendanceCard({
    super.key,
    required this.item,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final employeeName =
        item.employeeName.isEmpty ? item.employee : item.employeeName;

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
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.name,
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              HrStatusBadge(label: item.status, color: statusColor),
            ],
          ),
          const SizedBox(height: 16),
          HrInfoLine(
            icon: Icons.badge_outlined,
            label: 'Employee',
            value: item.employee,
            accentColor: const Color(0xFF2ECC71),
          ),
          const SizedBox(height: 8),
          HrInfoLine(
            icon: Icons.date_range_outlined,
            label: 'Date',
            value: item.attendanceDate,
            accentColor: const Color(0xFF2ECC71),
          ),
          if (item.company != null && item.company!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            HrInfoLine(
              icon: Icons.business_outlined,
              label: 'Company',
              value: item.company!,
              accentColor: const Color(0xFF2ECC71),
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state for the attendance list.
class AttendanceEmptyState extends StatelessWidget {
  const AttendanceEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.access_time_outlined,
            size: 58,
            color: Color(0xFF2ECC71),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.noAttendanceFound,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.createAttendanceOrFilter,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Shared HR widgets used across multiple screens
// ─────────────────────────────────────────────

/// Generic status pill badge.
class HrStatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const HrStatusBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.withValues(alpha: .14),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

/// Generic icon + label: value row used in detail cards.
class HrInfoLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  const HrInfoLine({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(icon, size: 18, color: accentColor),
        const SizedBox(width: 9),
        Text(
          '$label: ',
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black45,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

/// Generic search box + filter chips shared across HR list screens.
class HrSearchFilter extends StatelessWidget {
  final TextEditingController controller;
  final String selectedFilter;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;
  final ValueChanged<String> onFilterChanged;
  final List<String> filterLabels;
  final String hintText;
  final Color accentColor;

  const HrSearchFilter({
    super.key,
    required this.controller,
    required this.selectedFilter,
    required this.onSearch,
    required this.onClear,
    required this.onFilterChanged,
    required this.filterLabels,
    required this.hintText,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark ? const Color(0xFF101A35) : Colors.white,
            border: Border.all(
              color: accentColor.withValues(alpha: .22),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onSearch,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
              if (controller.text.isNotEmpty)
                IconButton(
                  onPressed: onClear,
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filterLabels.map((filter) {
              final selected = selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: selected,
                  onSelected: (_) => onFilterChanged(filter),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Generic error view shown when any HR list fails to load.
class HrErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const HrErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        const Icon(Icons.error_outline, size: 64, color: Color(0xFFE74C3C)),
        const SizedBox(height: 16),
        Text(message, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(l10n.retry),
        ),
      ],
    );
  }
}
