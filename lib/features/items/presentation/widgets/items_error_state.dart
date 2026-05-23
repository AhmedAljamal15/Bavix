import 'package:flutter/material.dart';
import 'premium_empty_state.dart';

class ItemsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ItemsErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumEmptyState(
        icon: Icons.error_outline,
        title: 'Something went wrong',
        message: message,
        actionLabel: 'Retry',
        onAction: onRetry,
      ),
    );
  }
}
