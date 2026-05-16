class CreateSalesInvoiceRequest {
  final String customer;
  final String postingDate;
  final List<CreateSalesInvoiceItemRequest> items;

  const CreateSalesInvoiceRequest({
    required this.customer,
    required this.postingDate,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer': customer,
      'posting_date': postingDate,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class CreateSalesInvoiceItemRequest {
  final String itemCode;
  final double qty;
  final String salesOrder;
  final String soDetail;
  final double rate;

  const CreateSalesInvoiceItemRequest({
    required this.itemCode,
    required this.qty,
    required this.salesOrder,
    required this.soDetail,
    required this.rate,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_code': itemCode,
      'qty': qty,
      'sales_order': salesOrder,
      'so_detail': soDetail,
      'rate': rate,
    };
  }
}