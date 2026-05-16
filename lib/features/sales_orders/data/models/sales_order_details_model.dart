class SalesOrderItemDetailsModel {
  final String itemCode;
  final String itemName;
  final double qty;
  final String uom;
  final String warehouse;
  final double rate;
  final double amount;
  final String salesOrderItemId;

  const SalesOrderItemDetailsModel({
    required this.itemCode,
    required this.itemName,
    required this.qty,
    required this.uom,
    required this.warehouse,
    required this.rate,
    required this.amount,
    required this.salesOrderItemId,
  });

  factory SalesOrderItemDetailsModel.fromJson(Map<String, dynamic> json) {
    return SalesOrderItemDetailsModel(
      itemCode: json['item_code'] ?? '',
      itemName: json['item_name'] ?? '',
      qty: (json['qty'] as num?)?.toDouble() ?? 0,
      uom: json['uom'] ?? '',
      warehouse: json['warehouse'] ?? '',
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      salesOrderItemId: json['name'] ?? '',
    );
  }
}

class SalesOrderDetailsModel {
  final String name;
  final String customerName;
  final String status;
  final String transactionDate;
  final String deliveryDate;
  final String company;
  final String currency;
  final double totalQty;
  final double grandTotal;
  final String billingStatus;
  final String deliveryStatus;
  final List<SalesOrderItemDetailsModel> items;

  const SalesOrderDetailsModel({
    required this.name,
    required this.customerName,
    required this.status,
    required this.transactionDate,
    required this.deliveryDate,
    required this.company,
    required this.currency,
    required this.totalQty,
    required this.grandTotal,
    required this.billingStatus,
    required this.deliveryStatus,
    required this.items, 
  });

  factory SalesOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];

    return SalesOrderDetailsModel(
      name: json['name'] ?? '',
      customerName: json['customer_name'] ?? '',
      status: json['status'] ?? '',
      transactionDate: json['transaction_date'] ?? '',
      deliveryDate: json['delivery_date'] ?? '',
      company: json['company'] ?? '',
      currency: json['currency'] ?? '',
      totalQty: (json['total_qty'] as num?)?.toDouble() ?? 0,
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0,
      billingStatus: json['billing_status'] ?? '',
      deliveryStatus: json['delivery_status'] ?? '',
      items: itemsList
          .map(
            (e) =>
                SalesOrderItemDetailsModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),

     
    );
  }
}
