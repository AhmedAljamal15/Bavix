import 'package:flutter/material.dart';

/// A row showing an icon and text with a chevron — used in delivery note cards.
class DeliveryInfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const DeliveryInfoLine({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(icon, size: 17, color: const Color(0xFF60A5FA)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: dark ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Icon(
          Icons.chevron_right_rounded,
          color: dark ? Colors.white30 : Colors.black26,
        ),
      ],
    );
  }
}
