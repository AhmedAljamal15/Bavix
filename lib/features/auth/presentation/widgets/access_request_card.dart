import 'package:erp_sales/features/auth/data/models/access_request_item_model.dart';
import 'package:erp_sales/features/auth/presentation/widgets/avatar.dart';
import 'package:erp_sales/features/auth/presentation/widgets/info_line.dart';
import 'package:erp_sales/features/auth/presentation/widgets/status_chip.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AccessRequestCard extends StatelessWidget {
  final AccessRequestItemModel request;
  final String statusText;
  final Color statusColor;
  final bool isUpdating;
  final bool showActions;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const AccessRequestCard({super.key, 
    required this.request,
    required this.statusText,
    required this.statusColor,
    required this.isUpdating,
    required this.showActions,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF101A35) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF60A5FA).withValues(alpha: .16),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: dark ? .18 : .05),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Avatar(name: request.fullName),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.fullName.isEmpty
                          ? 'Unknown user'
                          : request.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: dark ? Colors.white : Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: dark ? Colors.white60 : Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(label: statusText, color: statusColor),
            ],
          ),
          const SizedBox(height: 14),
          InfoLine(
            icon: Icons.person_outline,
            text: 'Owner: ${request.owner}',
          ),
          const SizedBox(height: 8),
          InfoLine(
            icon: Icons.tag_outlined,
            text: 'Request ID: ${request.id}',
          ),
          if (showActions) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isUpdating ? null : onReject,
                    icon: const Icon(Icons.close_rounded),
                    label: Text(AppLocalizations.of(context)!.reject),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isUpdating ? null : onApprove,
                    icon: isUpdating
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_rounded),
                    label: Text(AppLocalizations.of(context)!.approve),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF60A5FA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
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