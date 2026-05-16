import 'package:erp_sales/features/hr/data/models/attendance_model.dart';
import 'package:erp_sales/features/hr/data/remote/attendance_api_service.dart';

class AttendanceRepository {
  final AttendanceApiService apiService;

  AttendanceRepository(this.apiService);

  Future<List<AttendanceModel>> getAttendance() async {
    return apiService.getAttendance();
  }

  Future<void> createAttendance(CreateAttendanceRequest request) async {
    await apiService.createAttendance(request);
  }

  Future<List<Map<String, dynamic>>> getEmployees() async {
    return apiService.getEmployees();
  }

  Future<List<String>> getCompanies() async {
    return apiService.getCompanies();
  }
}