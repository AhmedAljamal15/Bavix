import 'package:erp_sales/features/sales_orders/data/models/create_sales_order_request.dart';
import 'package:erp_sales/features/sales_orders/data/remote/create_sales_order_api_service.dart';

class CreateSalesOrderRepository {
  final CreateSalesOrderApiService apiService;

  CreateSalesOrderRepository(this.apiService);

  Future<String> createSalesOrder(CreateSalesOrderRequest request) {
    return apiService.createSalesOrder(request);
  }
}