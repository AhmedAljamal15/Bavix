import 'package:flutter/material.dart';

/// Header bar for the sales invoices list view.
class InvoiceHeaderBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onAdd;

  const InvoiceHeaderBar({
    super.key,
    required this.onBack,
    required this.onAdd,
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
        const Icon(Icons.receipt_long_outlined, color: Color(0xFF60A5FA)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Sales Invoices',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        InkWell(
          onTap: onAdd,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
              ),
            ),
            child: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
