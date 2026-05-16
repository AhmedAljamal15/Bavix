import 'package:dio/dio.dart';
import 'package:erp_sales/features/sales_orders/data/models/create_sales_order_request.dart';

class CreateSalesOrderApiService {
  final Dio dio;

  CreateSalesOrderApiService(this.dio);

  Future<String> createSalesOrder(CreateSalesOrderRequest request) async {
    final response = await dio.post(
      '/api/resource/Sales Order',
      data: request.toJson(),
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.data.toString());
    }

    return response.data['data']['name'] as String;
  }
}