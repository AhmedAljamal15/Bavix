import 'package:erp_sales/features/items/data/models/warehouse_model.dart';
import 'package:erp_sales/features/items/data/remote/warehouse_api_service.dart';

class WarehouseRepository {
  final WarehouseApiService apiService;

  WarehouseRepository(this.apiService);

  Future<List<WarehouseModel>> getWarehouses() async {
    return apiService.getWarehouses();
  }
}