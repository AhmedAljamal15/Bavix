import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';

/// Top app bar for the sales invoice details screen.
class InvoiceDetailsTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  const InvoiceDetailsTopBar({
    super.key,
    required this.title,
    required this.onBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert_rounded,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          onSelected: (value) {
            if (value == 'refresh') {
              onRefresh();
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  const Icon(Icons.refresh_rounded),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.refresh),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
