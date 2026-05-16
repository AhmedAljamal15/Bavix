import 'package:flutter/material.dart';

class InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoLine({super.key, 
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: const Color(0xFF60A5FA),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: dark ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}