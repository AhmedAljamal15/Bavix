import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:erp_sales/core/widgets/premium_widgets.dart';

/// Error state for the sales orders screen with a retry action.
class OrdersError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const OrdersError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: EmptyStateWidget(
          icon: Icons.error_outline,
          title: l10n.somethingWentWrong,
          description: message,
          actionLabel: l10n.retry,
          onActionPressed: onRetry,
        ),
      ),
    );
  }
}
