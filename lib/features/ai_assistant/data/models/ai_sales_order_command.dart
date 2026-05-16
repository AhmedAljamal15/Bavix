class AiSalesOrderCommand {
  final String action;
  final String customer;
  final String transactionDate;
  final String deliveryDate;
  final List<AiSalesOrderItemCommand> items;

  const AiSalesOrderCommand({
    required this.action,
    required this.customer,
    required this.transactionDate,
    required this.deliveryDate,
    required this.items,
  });

  factory AiSalesOrderCommand.fromJson(Map<String, dynamic> json) {
    return AiSalesOrderCommand(
      action: json['action'] ?? '',
      customer: json['customer'] ?? '',
      transactionDate: json['transaction_date'] ?? '',
      deliveryDate: json['delivery_date'] ?? '',
      items: (json['items'] as List? ?? [])
          .map(
            (e) => AiSalesOrderItemCommand.fromJson(e),
          )
          .toList(),
    );
  }
}

class AiSalesOrderItemCommand {
  final String itemCode;
  final double qty;
  final double rate;

  const AiSalesOrderItemCommand({
    required this.itemCode,
    required this.qty,
    required this.rate,
  });

  factory AiSalesOrderItemCommand.fromJson(
    Map<String, dynamic> json,
  ) {
    return AiSalesOrderItemCommand(
      itemCode: json['item_code'] ?? '',
      qty: (json['qty'] as num?)?.toDouble() ?? 0,
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
    );
  }
}