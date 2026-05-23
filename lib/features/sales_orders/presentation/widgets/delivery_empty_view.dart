import 'package:flutter/material.dart';

/// Empty state for the delivery notes list screen.
class DeliveryEmptyView extends StatelessWidget {
  final String title;
  final String subtitle;

  const DeliveryEmptyView({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 60,
              color: dark ? Colors.white38 : Colors.black26,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                color: dark ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: dark ? Colors.white54 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
