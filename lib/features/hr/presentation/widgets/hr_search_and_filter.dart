import 'package:flutter/material.dart';

/// Search field + filter chip row for the HR workforce directory.
class HrSearchAndFilter extends StatelessWidget {
  final TextEditingController controller;
  final String selectedFilter;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;
  final ValueChanged<String> onFilterChanged;

  const HrSearchAndFilter({
    super.key,
    required this.controller,
    required this.selectedFilter,
    required this.onSearch,
    required this.onClear,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark ? const Color(0xFF101A35) : Colors.white,
            border: Border.all(
              color: const Color(0xFF60A5FA).withValues(alpha: .22),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onSearch,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search employees...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
              if (controller.text.isNotEmpty)
                IconButton(
                  onPressed: onClear,
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'System', 'Website', 'Enabled', 'Disabled']
                .map((filter) {
              final selected = selectedFilter == filter;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: selected,
                  onSelected: (_) => onFilterChanged(filter),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
