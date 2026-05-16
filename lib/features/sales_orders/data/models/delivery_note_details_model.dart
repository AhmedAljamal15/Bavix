class DeliveryNoteItemDetailsModel {
  final String itemCode;
  final String itemName;
  final double qty;
  final String uom;
  final String warehouse;
  final double rate;
  final double amount;

  const DeliveryNoteItemDetailsModel({
    required this.itemCode,
    required this.itemName,
    required this.qty,
    required this.uom,
    required this.warehouse,
    required this.rate,
    required this.amount,
  });

  factory DeliveryNoteItemDetailsModel.fromJson(Map<String, dynamic> json) {
    return DeliveryNoteItemDetailsModel(
      itemCode: json['item_code'] ?? '',
      itemName: json['item_name'] ?? '',
      qty: (json['qty'] as num?)?.toDouble() ?? 0,
      uom: json['uom'] ?? '',
      warehouse: json['warehouse'] ?? '',
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
    );
  }
}

class DeliveryNoteDetailsModel {
  final String name;
  final String customer;
  final String customerName;
  final String postingDate;
  final String status;
  final String company;
  final String currency;
  final double totalQty;
  final double grandTotal;
  final List<DeliveryNoteItemDetailsModel> items;

  const DeliveryNoteDetailsModel({
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

  factory DeliveryNoteDetailsModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];

    return DeliveryNoteDetailsModel(
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
          .map((e) => DeliveryNoteItemDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}