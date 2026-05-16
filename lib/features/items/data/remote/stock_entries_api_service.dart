import 'package:dio/dio.dart';
import 'package:erp_sales/features/items/data/models/inventory_bin_model.dart';
import 'package:erp_sales/features/items/data/models/stock_entry_model.dart';
import 'package:erp_sales/features/items/data/models/warehouse_model.dart';

class StockEntriesApiService {
  final Dio dio;

  StockEntriesApiService(this.dio);

  Future<List<StockEntryModel>> getStockEntries() async {
    final response = await dio.get(
      '/api/resource/Stock Entry',
      queryParameters: {
        'fields':
            '["name","stock_entry_type","posting_date","total_outgoing_value","total_incoming_value"]',
        'order_by': 'posting_date desc',
        'limit_page_length': 20,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data
        .map((e) => StockEntryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<WarehouseModel>> getWarehouses() async {
    final response = await dio.get(
      '/api/resource/Warehouse',
      queryParameters: {
        'fields': '["name","is_group"]',
        'limit_page_length': 100,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data
        .map((e) => WarehouseModel.fromJson(e as Map<String, dynamic>))
        .where((warehouse) => warehouse.isGroup == false)
        .toList();
  }

  Future<List<InventoryBinModel>> getInventoryBins() async {
    final response = await dio.get(
      '/api/resource/Bin',
      queryParameters: {
        'fields': '["item_code","warehouse","actual_qty"]',
        'filters': '[["Bin","actual_qty",">",0]]',
        'limit_page_length': 500,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data
        .map((e) => InventoryBinModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
