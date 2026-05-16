class CreateDeliveryNoteRequest {
  final String customer;
  final String postingDate;
  final List<CreateDeliveryNoteItemRequest> items;
  

  const CreateDeliveryNoteRequest({
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

class CreateDeliveryNoteItemRequest {
  final String itemCode;
  final double qty;
  final String warehouse;
  final String againstSalesOrder;
  final String againstSalesOrderItem;

  const CreateDeliveryNoteItemRequest({
    required this.itemCode,
    required this.qty,
    required this.warehouse,
    required this.againstSalesOrder, required this.againstSalesOrderItem,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_code': itemCode,
      'qty': qty,
      'warehouse': warehouse,
      'against_sales_order': againstSalesOrder,
      'so_detail': againstSalesOrderItem,
    };
  }
}
