class DeliveryNoteModel {
  final String name;
  final String customer;
  final String postingDate;
  final String status;
  final double grandTotal;

  const DeliveryNoteModel({
    required this.name,
    required this.customer,
    required this.postingDate,
    required this.status,
    required this.grandTotal,
  });

  factory DeliveryNoteModel.fromJson(Map<String, dynamic> json) {
    return DeliveryNoteModel(
      name: json['name'] ?? '',
      customer: json['customer'] ?? '',
      postingDate: json['posting_date'] ?? '',
      status: json['status'] ?? '',
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0,
    );
  }
}