import 'package:erp_sales/features/auth/data/models/hr_user_model.dart';
import 'package:flutter/material.dart';

/// Compact row card for a single user in the HR Workforce Directory.
class HrUserCard extends StatelessWidget {
  final HrUserModel user;

  const HrUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSystemUser = user.userType == 'System User';
    final color = isSystemUser
        ? const Color(0xFFF39C12)
        : const Color(0xFF9B59B6);
    final displayName = user.fullName.isEmpty ? user.name : user.fullName;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? const Color(0xFF0B1228) : const Color(0xFFF7F8FC),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: .04)
              : Colors.black.withValues(alpha: .04),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: .15),
            child: Text(
              displayName[0].toUpperCase(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${user.name} • ${user.userType}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: user.enabled
                  ? Colors.green.withValues(alpha: .12)
                  : Colors.red.withValues(alpha: .12),
            ),
            child: Text(
              user.enabled ? 'Enabled' : 'Disabled',
              style: TextStyle(
                color: user.enabled ? Colors.green : Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
