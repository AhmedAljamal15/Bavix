import 'package:flutter/material.dart';

/// Full customer list-item card with avatar, badge, group, and territory.
class CustomerCard extends StatelessWidget {
  final String name;
  final String id;
  final String type;
  final String group;
  final String territory;
  final bool isDark;

  const CustomerCard({
    super.key,
    required this.name,
    required this.id,
    required this.type,
    required this.group,
    required this.territory,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = type.toLowerCase() == 'company'
        ? const Color(0xFF9B59B6)
        : const Color(0xFF2ECC71);

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(color: typeColor.withValues(alpha: .18)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: isDark ? .16 : .05),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: typeColor.withValues(alpha: .14),
                ),
                child: Icon(
                  type.toLowerCase() == 'company'
                      ? Icons.business_outlined
                      : Icons.person_outline_rounded,
                  color: typeColor,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              CustomerTypeBadge(label: type, color: typeColor),
            ],
          ),
          const SizedBox(height: 14),
          CustomerInfoLine(
            icon: Icons.category_outlined,
            label: 'Group',
            value: group,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          CustomerInfoLine(
            icon: Icons.public_outlined,
            label: 'Territory',
            value: territory,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

/// A single icon + label + value row inside a CustomerCard.
class CustomerInfoLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const CustomerInfoLine({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: isDark ? Colors.white54 : Colors.black45),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.black45,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// Pill-shaped type badge (Individual / Company).
class CustomerTypeBadge extends StatelessWidget {
  final String label;
  final Color color;

  const CustomerTypeBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.withValues(alpha: .12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}
