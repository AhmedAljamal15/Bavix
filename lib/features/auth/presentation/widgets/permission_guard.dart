import 'package:flutter/material.dart';

class PermissionGuard extends StatelessWidget {
  final bool allowed;
  final Widget child;
  final Widget? fallback;

  const PermissionGuard({
    super.key,
    required this.allowed,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (allowed) return child;
    return fallback ?? const SizedBox.shrink();
  }
}