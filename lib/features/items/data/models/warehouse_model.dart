class WarehouseModel {
  final String name;
  final bool isGroup;

  const WarehouseModel({
    required this.name,
    required this.isGroup,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      name: json['name'] ?? '',
      isGroup: (json['is_group'] as int? ?? 0) == 1,
    );
  }
}