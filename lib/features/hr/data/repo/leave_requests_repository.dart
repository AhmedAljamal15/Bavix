import 'package:erp_sales/features/hr/data/models/leave_request_model.dart';
import 'package:erp_sales/features/hr/data/remote/leave_requests_api_service.dart';

class LeaveRequestsRepository {
  final LeaveRequestsApiService apiService;

  LeaveRequestsRepository(this.apiService);

  Future<List<LeaveRequestModel>> getLeaveRequests() async {
    return apiService.getLeaveRequests();
  }

  Future<void> createLeaveRequest(CreateLeaveRequestRequest request) async {
    await apiService.createLeaveRequest(request);
  }

  Future<List<String>> getLeaveTypes() async {
    return apiService.getLeaveTypes();
  }

  Future<List<Map<String, dynamic>>> getEmployees() async { 
    return apiService.getEmployees();
  }


  Future<void> updateLeaveRequestStatus({
  required String leaveRequestName,
  required String status,
}) async {
  await apiService.updateLeaveRequestStatus(
    leaveRequestName: leaveRequestName,
    status: status,
  );
}

Future<void> approveLeaveRequest(String leaveRequestName) async {
  await updateLeaveRequestStatus(
    leaveRequestName: leaveRequestName,
    status: 'Approved',
  );
}

Future<void> rejectLeaveRequest(String leaveRequestName) async {
  await updateLeaveRequestStatus(
    leaveRequestName: leaveRequestName,
    status: 'Rejected',
  );
}
}