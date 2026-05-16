class CustomerModel {
  final String name;
  final String customerName;
  final String? customerGroup;
  final String? territory;
  final String customerType;

  const CustomerModel({
    required this.name,
    required this.customerName,
    required this.customerGroup,
    required this.territory,
    required this.customerType,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      name: json['name'] as String? ?? '',
      customerName: json['customer_name'] as String? ?? '',
      customerGroup: json['customer_group'] as String?,
      territory: json['territory'] as String?,
      customerType: json['customer_type'] as String? ?? '',
    );
  }
}