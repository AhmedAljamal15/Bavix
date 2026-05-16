class CreateStockEntryRequest {
  final String stockEntryType;
  final List<CreateStockEntryItemRequest> items;

  const CreateStockEntryRequest({
    required this.stockEntryType,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'stock_entry_type': stockEntryType,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class CreateStockEntryItemRequest {
  final String itemCode;
  final double qty;
  final double basicRate;
  final String targetWarehouse;

  const CreateStockEntryItemRequest({
    required this.itemCode,
    required this.qty,
    required this.basicRate,
    required this.targetWarehouse,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_code': itemCode,
      'qty': qty,
      'basic_rate': basicRate,
      't_warehouse': targetWarehouse,
    };
  }
}