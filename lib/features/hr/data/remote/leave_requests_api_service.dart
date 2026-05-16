import 'package:dio/dio.dart';
import 'package:erp_sales/features/hr/data/models/leave_request_model.dart';

class LeaveRequestsApiService {
  final Dio dio;

  LeaveRequestsApiService(this.dio);

  Future<List<LeaveRequestModel>> getLeaveRequests() async {
    final response = await dio.get(
      '/api/resource/Leave Application',
      queryParameters: {
        'fields':
            '["name","employee","employee_name","leave_type","from_date","to_date","status"]',
        'order_by': 'from_date desc',
        'limit_page_length': 50,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data
        .map((e) => LeaveRequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createLeaveRequest(CreateLeaveRequestRequest request) async {
    final response = await dio.post(
      '/api/resource/Leave Application',
      data: request.toJson(),
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.data.toString());
    }
  }

  Future<List<String>> getLeaveTypes() async {
    final response = await dio.get(
      '/api/resource/Leave Type',
      queryParameters: {
        'fields': '["name"]',
        'limit_page_length': 100,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];
    return data.map((e) => (e['name'] ?? '').toString()).toList();
  }

  Future<List<Map<String, dynamic>>> getEmployees() async {
    final response = await dio.get(
      '/api/resource/Employee',
      queryParameters: {
        'fields': '["name","employee_name"]',
        'limit_page_length': 100,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];
    return data.map((e) => e as Map<String, dynamic>).toList();
  }

 
 Future<void> updateLeaveRequestStatus({
  required String leaveRequestName,
  required String status,
}) async {
  final response = await dio.put(
    '/api/resource/Leave Application/$leaveRequestName',
    data: {
      'status': status,
    },
    options: Options(validateStatus: (_) => true),
  );

  if (response.statusCode != 200) {
    throw Exception(response.data.toString());
  }
}


}