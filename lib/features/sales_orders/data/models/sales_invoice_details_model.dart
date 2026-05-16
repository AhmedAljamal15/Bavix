class SalesInvoiceItemDetailsModel {
  final String itemCode;
  final String itemName;
  final double qty;
  final String uom;
  final double rate;
  final double amount;

  const SalesInvoiceItemDetailsModel({
    required this.itemCode,
    required this.itemName,
    required this.qty,
    required this.uom,
    required this.rate,
    required this.amount,
  });

  factory SalesInvoiceItemDetailsModel.fromJson(Map<String, dynamic> json) {
    return SalesInvoiceItemDetailsModel(
      itemCode: json['item_code'] ?? '',
      itemName: json['item_name'] ?? '',
      qty: (json['qty'] as num?)?.toDouble() ?? 0,
      uom: json['uom'] ?? '',
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
    );
  }
}

class SalesInvoiceDetailsModel {
  final String name;
  final String customer;
  final String customerName;
  final String postingDate;
  final String status;
  final String company;
  final String currency;
  final double totalQty;
  final double grandTotal;
  final List<SalesInvoiceItemDetailsModel> items;

  const SalesInvoiceDetailsModel({
    required this.name,
    required this.customer,
    required this.customerName,
    required this.postingDate,
    required this.status,
    required this.company,
    required this.currency,
    required this.totalQty,
    required this.grandTotal,
    required this.items,
  });

  factory SalesInvoiceDetailsModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];

    return SalesInvoiceDetailsModel(
      name: json['name'] ?? '',
      customer: json['customer'] ?? '',
      customerName: json['customer_name'] ?? '',
      postingDate: json['posting_date'] ?? '',
      status: json['status'] ?? '',
      company: json['company'] ?? '',
      currency: json['currency'] ?? '',
      totalQty: (json['total_qty'] as num?)?.toDouble() ?? 0,
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0,
      items: itemsList
          .map((e) => SalesInvoiceItemDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}