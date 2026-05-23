import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';

/// Search box with filter button for the delivery notes screen.
class DeliveryNotesSearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String selectedStatus;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onStatusChanged;

  const DeliveryNotesSearchBox({
    super.key,
    required this.controller,
    required this.selectedStatus,
    required this.onChanged,
    required this.onStatusChanged,
  });

  void _openFilter(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statuses = ['All', 'Draft', 'To Bill', 'Completed', 'Cancelled'];

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Filter by status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                ...statuses.map((status) {
                  final selected = selectedStatus == status;
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    leading: Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selected
                          ? const Color(0xFF60A5FA)
                          : Colors.grey,
                    ),
                    title: Text(
                      status,
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.w900
                            : FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      onStatusChanged(status);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                    hintText: 'Search delivery notes...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _openFilter(context),
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
              label: Text('${l10n.statusLabel}: $selectedStatus'),
              deleteIcon: const Icon(Icons.close_rounded, size: 18),
              onDeleted: () => onStatusChanged('All'),
            ),
          ),
        ],
      ],
    );
  }
}
