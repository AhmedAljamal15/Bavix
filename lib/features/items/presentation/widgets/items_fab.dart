import 'package:flutter/material.dart';
import 'package:erp_sales/core/widgets/app_action_button.dart';

class ItemsFab extends StatelessWidget {
  final VoidCallback onCreateItem;
  final VoidCallback onCreateStockEntry;

  const ItemsFab({
    required this.onCreateItem,
    required this.onCreateStockEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppActionButton(
            onPressed: onCreateStockEntry,
            icon: Icons.inventory_outlined,
            label: 'Create Stock Entry',
          ),
          const SizedBox(height: 12),
          AppActionButton(
            onPressed: onCreateItem,
            icon: Icons.add_rounded,
            label: 'Add Item',
          ),
        ],
      ),
    );
  }
}
