import 'package:erp_sales/features/auth/data/models/access_request_item_model.dart';
import 'package:erp_sales/features/auth/data/remote/access_request_admin_api_service.dart';

class AccessRequestAdminRepository {
  final AccessRequestAdminApiService apiService;

  AccessRequestAdminRepository(this.apiService);

  Future<List<AccessRequestItemModel>> getAccessRequests() async {
    return apiService.getAccessRequests();
  }

  Future<void> approveRequest(String requestId) async {
    await apiService.updateAccessRequestStatus(
      requestId: requestId,
      status: 'Interested',
    );
  }

  Future<void> rejectRequest(String requestId) async {
    await apiService.updateAccessRequestStatus(
      requestId: requestId,
      status: 'Do Not Contact',
    );
  }
}