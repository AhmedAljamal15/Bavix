import 'package:flutter/material.dart';
import 'input_decorations.dart';

/// A premium number-only text field using the shared premium input decoration.
class PremiumNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const PremiumNumberField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF111827),
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecorations.premium(
        context: context,
        label: label,
        icon: icon,
      ),
    );
  }
}
