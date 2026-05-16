import 'package:erp_sales/features/items/data/models/create_stock_entry_request.dart';
import 'package:erp_sales/features/items/data/remote/create_stock_entry_api_service.dart';

class CreateStockEntryRepository {
  final CreateStockEntryApiService apiService;

  CreateStockEntryRepository(this.apiService);

  Future<String> createAndSubmitStockEntry(
    CreateStockEntryRequest request,
  ) async {
    return apiService.createAndSubmitStockEntry(request);
  }
}