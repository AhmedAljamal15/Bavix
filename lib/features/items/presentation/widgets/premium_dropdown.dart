import 'package:flutter/material.dart';
import 'input_decorations.dart';

/// Generic premium dropdown for selecting typed items.
class PremiumDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final IconData icon;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;

  const PremiumDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecorations.premium(
        context: context,
        label: label,
        icon: icon,
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabel(item),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
