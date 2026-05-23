import 'package:flutter/material.dart';

/// Skeleton loading state for item details screen.
class ItemSkeletonLoading extends StatelessWidget {
  const ItemSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF101A35) : Colors.white;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
      children: [
        Row(
          children: [
            SkeletonBox(width: 44, height: 44, color: baseColor),
            const Spacer(),
            SkeletonBox(width: 120, height: 20, color: baseColor),
            const Spacer(),
            SkeletonBox(width: 44, height: 44, color: baseColor),
          ],
        ),
        const SizedBox(height: 22),
        SkeletonBox(width: double.infinity, height: 260, color: baseColor),
        const SizedBox(height: 22),
        SkeletonBox(width: 180, height: 24, color: baseColor),
        const SizedBox(height: 12),
        SkeletonBox(width: double.infinity, height: 130, color: baseColor),
        const SizedBox(height: 22),
        SkeletonBox(width: 140, height: 24, color: baseColor),
        const SizedBox(height: 12),
        SkeletonBox(width: double.infinity, height: 94, color: baseColor),
      ],
    );
  }
}

/// A single rounded placeholder box used in skeleton loading states.
class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: .06)
              : Colors.black12,
        ),
      ),
    );
  }
}
