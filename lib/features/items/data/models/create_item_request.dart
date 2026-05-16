class CreateItemRequest {
  final String itemCode;
  final String itemName;
  final String itemGroup;
  final String stockUom;
  final String countryOfOrigin;
  final int isStockItem;
  final int isSalesItem;

  CreateItemRequest({
    required this.itemCode,
    required this.itemName,
    required this.itemGroup,
    required this.stockUom,
    required this.countryOfOrigin,
    required this.isStockItem,
    required this.isSalesItem,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_code': itemCode,
      'item_name': itemName,
      'item_group': itemGroup,
      'stock_uom': stockUom,
      'country_of_origin': countryOfOrigin,
      'is_stock_item': isStockItem,
      'is_sales_item': isSalesItem,
    };
  }
}
