import 'package:flutter/material.dart';

class AiHeaderButton extends StatelessWidget {
  final VoidCallback onTap;

  const AiHeaderButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0EA5E9),
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
            ],
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              offset: const Offset(0, 6),
              color: const Color(0xFF6366F1).withValues(alpha: .32),
            ),
          ],
        ),
        child: const Icon(
          Icons.auto_awesome_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}