import '../models/item_model.dart';
import '../remote/item_details_api_service.dart';

class ItemDetailsRepository {
  final ItemDetailsApiService apiService;

  ItemDetailsRepository(this.apiService);

  Future<ItemModel> getItemDetails(String itemId) async {
    return apiService.getItemDetails(itemId);
  }
}