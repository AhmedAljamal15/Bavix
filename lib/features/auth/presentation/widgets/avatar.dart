import 'package:flutter/widgets.dart';

class Avatar extends StatelessWidget {
  final String name;

  const Avatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final letter = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFF60A5FA).withValues(alpha: .14),
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: Color(0xFF60A5FA),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}