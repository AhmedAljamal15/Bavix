import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Toggle selector for Individual / Company customer types.
class CustomerTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;

  static const Color _success = Color(0xFF2ECC71);
  static const Color _purple = Color(0xFF9B59B6);

  const CustomerTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.customerType,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CustomerTypeCard(
                title: l10n.individual,
                icon: Icons.person_outline_rounded,
                color: _success,
                selected: selectedType == 'Individual',
                onTap: () => onChanged('Individual'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomerTypeCard(
                title: l10n.company,
                icon: Icons.business_outlined,
                color: _purple,
                selected: selectedType == 'Company',
                onTap: () => onChanged('Company'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Individual selectable card used inside [CustomerTypeSelector].
class CustomerTypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const CustomerTypeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 86,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected
              ? color.withValues(alpha: isDark ? .18 : .12)
              : isDark
              ? const Color(0xFF0B1228)
              : const Color(0xFFF9FAFB),
          border: Border.all(
            color: selected
                ? color.withValues(alpha: .75)
                : isDark
                ? Colors.white.withValues(alpha: .08)
                : Colors.black12,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: color.withValues(alpha: .14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
