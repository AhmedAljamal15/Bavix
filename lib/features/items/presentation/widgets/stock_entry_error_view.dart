import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'create_item_top_bar.dart';

/// Error view for the create stock entry screen — shows a title bar and retry button.
class StockEntryErrorView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  const StockEntryErrorView({
    super.key,
    required this.title,
    required this.message,
    required this.onBack,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
      children: [
        CreateItemTopBar(title: title, onBack: onBack),
        const SizedBox(height: 120),
        Icon(
          Icons.error_outline_rounded,
          size: 70,
          color: const Color(0xFFEF4444).withValues(alpha: .9),
        ),
        const SizedBox(height: 16),
        Text(
          'Something went wrong',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
            fontWeight: FontWeight.w900,
            fontSize: 20,
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
