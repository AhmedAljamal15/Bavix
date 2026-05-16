class ItemModel {
  final String name;
  final String itemCode;
  final String itemName;
  final String itemGroup;
  final String stockUom;
  final double standardRate;
  final bool isStockItem;
  final bool isSalesItem;
  final bool disabled;
  final String countryOfOrigin;

  const ItemModel({
    required this.name,
    required this.itemCode,
    required this.itemName,
    required this.itemGroup,
    required this.stockUom,
    required this.standardRate,
    required this.isStockItem,
    required this.isSalesItem,
    required this.disabled,
    required this.countryOfOrigin,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      name: json['name'] as String? ?? '',
      itemCode: json['item_code'] as String? ?? '',
      itemName: json['item_name'] as String? ?? '',
      itemGroup: json['item_group'] as String? ?? '',
      stockUom: json['stock_uom'] as String? ?? '',
      standardRate: (json['standard_rate'] as num?)?.toDouble() ?? 0.0,
      isStockItem: (json['is_stock_item'] as num? ?? 0) == 1,
      isSalesItem: (json['is_sales_item'] as num? ?? 0) == 1,
      disabled: (json['disabled'] as num? ?? 0) == 1,
      countryOfOrigin: json['country_of_origin'] as String? ?? '',
    );
  }
}