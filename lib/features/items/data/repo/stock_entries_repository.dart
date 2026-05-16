import 'package:erp_sales/features/items/data/models/inventory_bin_model.dart';
import 'package:erp_sales/features/items/data/models/stock_entry_model.dart';
import 'package:erp_sales/features/items/data/models/warehouse_model.dart';
import 'package:erp_sales/features/items/data/remote/stock_entries_api_service.dart';

class StockEntriesRepository {
  final StockEntriesApiService apiService;

  StockEntriesRepository(this.apiService);

  Future<List<StockEntryModel>> getStockEntries() async {
    return apiService.getStockEntries();
  }

  Future<List<WarehouseModel>> getWarehouses() async {
    return apiService.getWarehouses();
  }


  Future<List<InventoryBinModel>> getInventoryBins() async {
  return apiService.getInventoryBins();
}
}