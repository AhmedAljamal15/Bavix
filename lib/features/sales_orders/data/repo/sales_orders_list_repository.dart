import 'package:erp_sales/features/sales_orders/data/models/sales_order_model.dart';
import 'package:erp_sales/features/sales_orders/data/remote/sales_orders_list_api_service.dart';

class SalesOrdersListRepository {
  final SalesOrdersListApiService apiService;

  SalesOrdersListRepository(this.apiService);

  Future<List<SalesOrderModel>> getSalesOrders() async {
    try {
      return await apiService.getSalesOrders();
    } catch (e) {
      rethrow;
    }
  }
}
