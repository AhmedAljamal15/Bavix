import 'package:erp_sales/features/sales_orders/data/models/sales_order_details_model.dart';
import 'package:erp_sales/features/sales_orders/data/remote/sales_order_details_api_service.dart';

class SalesOrderDetailsRepository {
  final SalesOrderDetailsApiService apiService;

  SalesOrderDetailsRepository(this.apiService);

  Future<SalesOrderDetailsModel> getOrderDetails(
    String orderId,
  ) async {
    return apiService.getOrderDetails(orderId);
  }
}