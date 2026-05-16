import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SearchFilterBox extends StatelessWidget {
  final TextEditingController controller;
  final String selectedStatus;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;
  final VoidCallback onClearFilter;

  const SearchFilterBox({super.key, 
    required this.controller,
    required this.selectedStatus,
    required this.onChanged,
    required this.onFilterTap,
    required this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF101A35) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF60A5FA).withValues(alpha: .18),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(
                Icons.search_rounded,
                color: dark ? Colors.white54 : Colors.black45,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search requests...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: onFilterTap,
                icon: Icon(
                  Icons.filter_alt_outlined,
                  color: selectedStatus == 'All'
                      ? (dark ? Colors.white54 : Colors.black54)
                      : const Color(0xFF60A5FA),
                ),
              ),
            ],
          ),
        ),
        if (selectedStatus != 'All') ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              label: Text('${AppLocalizations.of(context)!.statusLabel}: $selectedStatus'),
              deleteIcon: const Icon(Icons.close_rounded, size: 18),
              onDeleted: onClearFilter,
            ),
          ),
        ],
      ],
    );
  }
}