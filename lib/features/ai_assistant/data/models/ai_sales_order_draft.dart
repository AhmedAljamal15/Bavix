import 'package:erp_sales/features/sales_orders/data/models/create_sales_order_request.dart';

class AiSalesOrderDraft {
  final String customer;
  final String transactionDate;
  final String deliveryDate;
  final List<AiSalesOrderDraftItem> items;

  const AiSalesOrderDraft({
    required this.customer,
    required this.transactionDate,
    required this.deliveryDate,
    required this.items,
  });

  double get total {
    return items.fold(0, (sum, item) => sum + item.total);
  }

  CreateSalesOrderRequest toRequest() {
    return CreateSalesOrderRequest(
      customer: customer,
      transactionDate: transactionDate,
      deliveryDate: deliveryDate,
      items: items.map((item) {
        return CreateSalesOrderItemRequest(
          itemCode: item.itemCode,
          qty: item.qty,
          rate: item.rate,
        );
      }).toList(),
    );
  }
}

class AiSalesOrderDraftItem {
  final String itemCode;
  final double qty;
  final double rate;

  const AiSalesOrderDraftItem({
    required this.itemCode,
    required this.qty,
    required this.rate,
  });

  double get total => qty * rate;
}