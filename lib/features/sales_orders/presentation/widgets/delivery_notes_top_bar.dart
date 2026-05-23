import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';

/// Top bar for the delivery notes and similar list screens.
class DeliveryNotesTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const DeliveryNotesTopBar({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 18, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: dark ? Colors.white : Colors.black87,
            ),
          ),
          const Icon(
            Icons.local_shipping_outlined,
            color: Color(0xFF60A5FA),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: dark ? Colors.white : Colors.black87,
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
