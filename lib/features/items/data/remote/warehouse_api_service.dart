import 'package:dio/dio.dart';
import 'package:erp_sales/features/items/data/models/warehouse_model.dart';

class WarehouseApiService {
  final Dio dio;

  WarehouseApiService(this.dio);

  Future<List<WarehouseModel>> getWarehouses() async {
    final response = await dio.get(
      '/api/resource/Warehouse',
      queryParameters: {
        'fields': '["name","is_group"]',
        'limit_page_length': 100,
      },
    );

    final data = response.data['data'] as List;

    return data
        .map((e) => WarehouseModel.fromJson(e))
        .where((warehouse) => warehouse.isGroup == false)
        .toList();
  }
}