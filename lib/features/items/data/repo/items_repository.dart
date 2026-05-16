import '../models/item_model.dart';
import '../models/create_item_request.dart';
import '../remote/items_api_service.dart';

class ItemsRepository {
  final ItemsApiService apiService;

  ItemsRepository(this.apiService);

  Future<List<ItemModel>> getItems() async {
    return apiService.getItems();
  }

  Future<void> createItem(CreateItemRequest request) async {
    return apiService.createItem(request);
  }
}
