class SalesInvoiceModel {
  final String name;
  final String customer;
  final String postingDate;
  final String status;
  final double grandTotal;
  final String currency;

  const SalesInvoiceModel({
    required this.name,
    required this.customer,
    required this.postingDate,
    required this.status,
    required this.grandTotal,
    required this.currency,
  });

  factory SalesInvoiceModel.fromJson(Map<String, dynamic> json) {
    return SalesInvoiceModel(
      name: json['name'] ?? '',
      customer: json['customer'] ?? '',
      postingDate: json['posting_date'] ?? '',
      status: json['status'] ?? '',
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] ?? '',
    );
  }
}