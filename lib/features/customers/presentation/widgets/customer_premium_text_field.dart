import 'package:flutter/material.dart';

/// A styled text field used in the create-customer form.
class CustomerPremiumTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;

  static const Color _primary = Color(0xFF60A5FA);

  const CustomerPremiumTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    required this.textInputAction,
    this.nextFocusNode,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 10),
              child: Icon(icon, size: 21),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    onPressed: controller.clear,
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
            filled: true,
            fillColor: isDark
                ? const Color(0xFF0B1228)
                : const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            labelStyle: TextStyle(
              color: isDark ? Colors.white60 : Colors.black54,
              fontWeight: FontWeight.w700,
            ),
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Colors.black38,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: .08)
                    : Colors.black12,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: _primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 1.4,
              ),
            ),
          ),
        );
      },
    );
  }
}
