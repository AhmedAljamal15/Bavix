import 'package:flutter/material.dart';

/// Gradient hero header at the top of the HR Dashboard screen.
class HrHeroHeader extends StatelessWidget {
  final int totalUsers;
  final VoidCallback onBack;
  final VoidCallback onProfile;

  const HrHeroHeader({
    super.key,
    required this.totalUsers,
    required this.onBack,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 44, 18, 34),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF020617),
                  const Color(0xFF072A35),
                  const Color(0xFF0E1738),
                ]
              : [const Color(0xFFEFF6FF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
              const Icon(Icons.badge_outlined, color: Color(0xFF60A5FA)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'HR Dashboard',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed: onProfile,
                icon: Icon(
                  Icons.person_outline,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            'HR Command Center',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Manage employees, leave requests, payroll readiness and workforce access.',
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
              color: const Color(0xFF60A5FA).withValues(alpha: .14),
            ),
            child: Text(
              '$totalUsers users loaded',
              style: const TextStyle(
                color: Color(0xFF60A5FA),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
