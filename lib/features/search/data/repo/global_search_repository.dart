import 'package:erp_sales/features/search/data/models/global_search_result_model.dart';
import 'package:erp_sales/features/search/data/remote/global_search_api_service.dart';

class GlobalSearchRepository {
  final GlobalSearchApiService apiService;

  GlobalSearchRepository(this.apiService);

  Future<List<GlobalSearchResultModel>> search(String query) async {
    return apiService.search(query);
  }
}