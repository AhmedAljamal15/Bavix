class InventoryBinModel {
  final String itemCode;
  final String warehouse;
  final double actualQty;

  const InventoryBinModel({
    required this.itemCode,
    required this.warehouse,
    required this.actualQty,
  });

  factory InventoryBinModel.fromJson(Map<String, dynamic> json) {
    return InventoryBinModel(
      itemCode: json['item_code'] ?? '',
      warehouse: json['warehouse'] ?? '',
      actualQty: (json['actual_qty'] as num?)?.toDouble() ?? 0,
    );
  }
}