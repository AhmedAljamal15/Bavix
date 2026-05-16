import 'package:dio/dio.dart';
import '../models/item_model.dart';
import '../models/create_item_request.dart';

class ItemsApiService {
  final Dio dio;

  ItemsApiService(this.dio);

  Future<List<ItemModel>> getItems() async {
    final response = await dio.get(
      '/api/resource/Item',
      queryParameters: {
        'fields':
            '["name","item_code","item_name","item_group","stock_uom","standard_rate","is_stock_item","is_sales_item","disabled","country_of_origin"]',
      },
    );

    final List items = response.data['data'] as List? ?? [];

    return items
        .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createItem(CreateItemRequest request) async {
    final response = await dio.post(
      '/api/resource/Item',
      data: request.toJson(),
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.data.toString());
    }
  }
}
