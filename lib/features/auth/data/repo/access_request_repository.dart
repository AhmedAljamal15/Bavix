import 'package:erp_sales/features/auth/data/models/access_request.dart';
import 'package:erp_sales/features/auth/data/remote/access_request_api_service.dart';

class AccessRequestRepository {
  final AccessRequestApiService apiService;

  AccessRequestRepository(this.apiService);

  Future<String> createAccessRequest(AccessRequest request) async {
    return apiService.createAccessRequest(request);
  }
}