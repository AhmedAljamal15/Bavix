import 'package:flutter/material.dart';
import 'package:erp_sales/features/search/data/models/global_search_result_model.dart';
import 'search_filter_chip_item.dart';

/// Horizontal scrollable bar displaying type filters for the global search.
class SearchFilterBar extends StatelessWidget {
  final GlobalSearchResultType? selectedType;
  final ValueChanged<GlobalSearchResultType?> onChanged;

  const SearchFilterBar({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SearchFilterChipItem(
            label: 'All',
            selected: selectedType == null,
            onTap: () => onChanged(null),
          ),
          SearchFilterChipItem(
            label: 'Customers',
            selected: selectedType == GlobalSearchResultType.customer,
            onTap: () => onChanged(GlobalSearchResultType.customer),
          ),
          SearchFilterChipItem(
            label: 'Items',
            selected: selectedType == GlobalSearchResultType.item,
            onTap: () => onChanged(GlobalSearchResultType.item),
          ),
          SearchFilterChipItem(
            label: 'Orders',
            selected: selectedType == GlobalSearchResultType.salesOrder,
            onTap: () => onChanged(GlobalSearchResultType.salesOrder),
          ),
          SearchFilterChipItem(
            label: 'Invoices',
            selected: selectedType == GlobalSearchResultType.salesInvoice,
            onTap: () => onChanged(GlobalSearchResultType.salesInvoice),
          ),
          SearchFilterChipItem(
            label: 'Deliveries',
            selected: selectedType == GlobalSearchResultType.deliveryNote,
            onTap: () => onChanged(GlobalSearchResultType.deliveryNote),
          ),
        ],
      ),
    );
  }
}
