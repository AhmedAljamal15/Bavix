import 'package:dio/dio.dart';
import 'package:erp_sales/features/sales_orders/data/models/sales_order_details_model.dart';

class SalesOrderDetailsApiService {
  final Dio dio;

  SalesOrderDetailsApiService(this.dio);

  Future<SalesOrderDetailsModel> getOrderDetails(
    String orderId,
  ) async {
    final response = await dio.get(
      '/api/resource/Sales Order/$orderId',
    );

    return SalesOrderDetailsModel.fromJson(
      response.data['data'],
    );
  }
}