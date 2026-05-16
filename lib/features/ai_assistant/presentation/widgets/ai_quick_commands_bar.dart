import 'package:flutter/material.dart';

class AiQuickCommandsBar extends StatelessWidget {
  final List<String> commands;
  final ValueChanged<String> onTap;

  const AiQuickCommandsBar({
    super.key,
    required this.commands,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: commands.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final command = commands[index];

          return ActionChip(
            avatar: const Icon(Icons.auto_awesome_rounded, size: 16),
            label: Text(command),
            onPressed: () => onTap(command),
          );
        },
      ),
    );
  }
}
