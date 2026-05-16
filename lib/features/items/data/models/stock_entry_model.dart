class StockEntryModel {
  final String name;
  final String stockEntryType;
  final String postingDate;
  final double totalOutgoingValue;
  final double totalIncomingValue;

  const StockEntryModel({
    required this.name,
    required this.stockEntryType,
    required this.postingDate,
    required this.totalOutgoingValue,
    required this.totalIncomingValue,
  });

  factory StockEntryModel.fromJson(Map<String, dynamic> json) {
    return StockEntryModel(
      name: json['name'] ?? '',
      stockEntryType: json['stock_entry_type'] ?? '',
      postingDate: json['posting_date'] ?? '',
      totalOutgoingValue:
          (json['total_outgoing_value'] as num?)?.toDouble() ?? 0,
      totalIncomingValue:
          (json['total_incoming_value'] as num?)?.toDouble() ?? 0,
    );
  }
}