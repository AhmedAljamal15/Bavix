import 'package:dio/dio.dart';
import 'package:erp_sales/features/hr/data/models/attendance_model.dart';

class AttendanceApiService {
  final Dio dio;

  AttendanceApiService(this.dio);

  Future<List<AttendanceModel>> getAttendance() async {
    final response = await dio.get(
      '/api/resource/Attendance',
      queryParameters: {
        'fields':
            '["name","employee","employee_name","attendance_date","status","company"]',
        'order_by': 'attendance_date desc',
        'limit_page_length': 100,
      },
      options: Options(
        validateStatus: (_) => true,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data
        .map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createAttendance(CreateAttendanceRequest request) async {
    final response = await dio.post(
      '/api/resource/Attendance',
      data: request.toJson(),
      options: Options(
        validateStatus: (_) => true,
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.data.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getEmployees() async {
    final response = await dio.get(
      '/api/resource/Employee',
      queryParameters: {
        'fields': '["name","employee_name"]',
        'filters': '[["status","=","Active"]]',
        'limit_page_length': 100,
      },
      options: Options(
        validateStatus: (_) => true,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<List<String>> getCompanies() async {
    final response = await dio.get(
      '/api/resource/Company',
      queryParameters: {
        'fields': '["name"]',
        'limit_page_length': 100,
      },
      options: Options(
        validateStatus: (_) => true,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data
        .map((e) => (e as Map<String, dynamic>)['name']?.toString() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
  }
}