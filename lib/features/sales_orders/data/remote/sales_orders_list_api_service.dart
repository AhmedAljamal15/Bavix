import 'package:dio/dio.dart';
import 'package:erp_sales/features/sales_orders/data/models/sales_order_model.dart';

class SalesOrdersListApiService {
  final Dio dio;

  SalesOrdersListApiService(this.dio);

  Future<List<SalesOrderModel>> getSalesOrders() async {
    try {
      final response = await dio.get(
        '/api/resource/Sales Order',
        queryParameters: {
          'fields':
              '["name","customer","transaction_date","delivery_date","status","grand_total"]',
        },
      );

      final List orders = response.data['data'] as List? ?? [];

      return orders
          .map((e) => SalesOrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch sales orders: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching sales orders: $e');
    }
  }
}
