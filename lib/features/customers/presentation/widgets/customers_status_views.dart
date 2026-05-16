import 'package:erp_sales/features/customers/presentation/widgets/customers_empty_state.dart';
import 'package:flutter/material.dart';

/// Full-screen loading indicator for the customers list.
class CustomersLoadingView extends StatelessWidget {
  const CustomersLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

/// Full-screen error view for the customers list.
class CustomersErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CustomersErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomersEmptyState(
        icon: Icons.error_outline,
        title: 'Something went wrong',
        message: message,
        actionLabel: 'Retry',
        onAction: onRetry,
      ),
    );
  }
}
