class SalesOrderModel {
  final String name;
  final String customer;
  final String transactionDate;
  final String deliveryDate;
  final String status;
  final double grandTotal;

  const SalesOrderModel({
    required this.name,
    required this.customer,
    required this.transactionDate,
    required this.deliveryDate,
    required this.status,
    required this.grandTotal,
  });

  factory SalesOrderModel.fromJson(Map<String, dynamic> json) {
    return SalesOrderModel(
      name: json['name'] as String? ?? '',
      customer: json['customer'] as String? ?? '',
      transactionDate: json['transaction_date'] as String? ?? '',
      deliveryDate: json['delivery_date'] as String? ?? '',
      status: json['status'] as String? ?? '',
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}