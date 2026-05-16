class CreateSalesOrderRequest {
  final String customer;
  final String transactionDate;
  final String deliveryDate;
  final List<CreateSalesOrderItemRequest> items;

  const CreateSalesOrderRequest({
    required this.customer,
    required this.transactionDate,
    required this.deliveryDate,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer': customer,
      'transaction_date': transactionDate,
      'delivery_date': deliveryDate,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class CreateSalesOrderItemRequest {
  final String itemCode;
  final double qty;
  final double rate;

  const CreateSalesOrderItemRequest({
    required this.itemCode,
    required this.qty,
    required this.rate,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_code': itemCode,
      'qty': qty,
      'rate': rate,
    };
  }
}