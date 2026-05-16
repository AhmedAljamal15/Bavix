
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Gradient hero header + tab bar for the Payroll screen.
class PayrollHeader extends StatelessWidget {
  final bool isDark;
  final TabController controller;
  final int slipsCount;
  final int entriesCount;
  final int submittedCount;
  final int draftCount;

  const PayrollHeader({
    super.key,
    required this.isDark,
    required this.controller,
    required this.slipsCount,
    required this.entriesCount,
    required this.submittedCount,
    required this.draftCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 46, 18, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF020617), const Color(0xFF172554), const Color(0xFF101A35)]
              : [const Color(0xFFEFF6FF), const Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: isDark ? Colors.white : const Color(0xFF111827)),
              ),
              Expanded(
                child: Text(l10n.payroll,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        fontSize: 25, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: isDark ? Colors.white.withValues(alpha: .07) : Colors.white,
              border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: .16)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20, offset: const Offset(0, 10),
                  color: Colors.black.withValues(alpha: isDark ? .20 : .06),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 68, width: 68,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF60A5FA)]),
                  ),
                  child: const Icon(Icons.account_balance_wallet_outlined,
                      color: Colors.white, size: 34),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.payrollManagement,
                          style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF111827),
                              fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 5),
                      Text(l10n.trackPayrollDescription,
                          style: TextStyle(
                              color: isDark ? Colors.white60 : Colors.black54,
                              fontSize: 12.5, height: 1.4, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PayrollStatsGrid(
            children: [
              PayrollStatCard(
                title: l10n.salarySlips, value: slipsCount.toString(),
                icon: Icons.receipt_long_outlined,
                color: const Color(0xFF2563EB), isDark: isDark,
              ),
              PayrollStatCard(
                title: l10n.payrollEntries, value: entriesCount.toString(),
                icon: Icons.payments_outlined,
                color: const Color(0xFFF39C12), isDark: isDark,
              ),
              PayrollStatCard(
                title: l10n.submitted, value: submittedCount.toString(),
                icon: Icons.verified_outlined,
                color: const Color(0xFF2ECC71), isDark: isDark,
              ),
              PayrollStatCard(
                title: l10n.draft, value: draftCount.toString(),
                icon: Icons.edit_note_outlined,
                color: const Color(0xFF9B59B6), isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 52,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
              borderRadius: BorderRadius.circular(18),
            ),
            child: TabBar(
              controller: controller,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12, offset: const Offset(0, 6),
                    color: const Color(0xFF2563EB).withValues(alpha: .28),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: isDark ? Colors.white70 : Colors.black54,
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
              tabs: [Tab(text: l10n.salarySlips), Tab(text: l10n.payrollEntries)],
            ),
          ),
        ],
      ),
    );
  }
}

class PayrollStatsGrid extends StatelessWidget {
  final List<Widget> children;
  const PayrollStatsGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        const spacing = 10.0;
        final width = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing, runSpacing: spacing,
          children: children.map((c) => SizedBox(width: width, child: c)).toList(),
        );
      },
    );
  }
}

class PayrollStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const PayrollStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: .07) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: .18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value,
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  fontSize: 21, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Expanded(
            child: Text(title,
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 11, height: 1.15, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

/// Tappable card for a single payroll entry or salary slip.
class PayrollCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final Color color;
  final List<PayrollDetailLine> details;
  final VoidCallback onTap;

  const PayrollCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.color,
    required this.details,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF101A35) : Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: color.withValues(alpha: .18)),
          boxShadow: [
            BoxShadow(
              blurRadius: 16, offset: const Offset(0, 8),
              color: Colors.black.withValues(alpha: isDark ? .16 : .05),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 50, width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: color.withValues(alpha: .13),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF111827),
                              fontSize: 16, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(subtitle,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.black54,
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                PayrollStatusChip(label: status, color: color),
              ],
            ),
            const SizedBox(height: 14),
            ...details,
          ],
        ),
      ),
    );
  }
}

class PayrollDetailLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const PayrollDetailLine({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Icon(icon, size: 17, color: const Color(0xFF2563EB)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 12.5, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class PayrollStatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const PayrollStatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final text = label.isEmpty ? l10n.unknown : label;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(text,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900)),
    );
  }
}

class PayrollEmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const PayrollEmptyView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 46, 16, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF101A35) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: .14)),
          ),
          child: Column(
            children: [
              Container(
                height: 74, width: 74,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: const Color(0xFF2563EB).withValues(alpha: .12),
                ),
                child: Icon(icon, color: const Color(0xFF2563EB), size: 36),
              ),
              const SizedBox(height: 16),
              Text(title,
                  style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      fontSize: 19, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54,
                      height: 1.45, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

class PayrollErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const PayrollErrorView({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 90),
        const Icon(Icons.error_outline, color: Color(0xFFE74C3C), size: 64),
        const SizedBox(height: 14),
        Text(error, textAlign: TextAlign.center),
        const SizedBox(height: 18),
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(l10n.retry),
        ),
      ],
    );
  }
}
