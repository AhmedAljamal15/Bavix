import 'package:dio/dio.dart';
import '../models/item_model.dart';

class ItemDetailsApiService {
  final Dio dio;

  ItemDetailsApiService(this.dio);

  Future<ItemModel> getItemDetails(String itemId) async {
    final encodedItemId = Uri.encodeComponent(itemId);

    final response = await dio.get(
      '/api/resource/Item/$encodedItemId',
    );

    return ItemModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}