import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';

/// Error view shown when item details or stock entry fails to load.
class ItemErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ItemErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const SizedBox(height: 140),
        Icon(
          Icons.error_outline,
          size: 70,
          color: const Color(0xFFEF4444).withValues(alpha: .9),
        ),
        const SizedBox(height: 16),
        Text(
          'Something went wrong',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
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
