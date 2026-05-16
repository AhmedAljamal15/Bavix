import 'package:dio/dio.dart';
import 'package:erp_sales/features/hr/data/models/employee_model.dart';

class EmployeesApiService {
  final Dio dio;

  EmployeesApiService(this.dio);

  Future<void> createEmployee(CreateEmployeeRequest request) async {
    final userResponse = await dio.get(
      '/api/method/frappe.auth.get_logged_user',
      options: Options(
        validateStatus: (_) => true,
        headers: {'Authorization': 'token fef621e196b5647:58c2cd5179236c9'},
      ),
    );

    throw Exception('TOKEN USER => ${userResponse.data}');
  }

  Future<List<String>> getCompanies() async {
    final response = await dio.get(
      '/api/resource/Company',
      queryParameters: {'fields': '["name"]', 'limit_page_length': 100},
      options: Options(validateStatus: (_) => true),
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

  Future<List<String>> getDepartments() async {
    final response = await dio.get(
      '/api/resource/Department',
      queryParameters: {'fields': '["name"]', 'limit_page_length': 100},
      options: Options(validateStatus: (_) => true),
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

  Future<List<String>> getDesignations() async {
    final response = await dio.get(
      '/api/resource/Designation',
      queryParameters: {'fields': '["name"]', 'limit_page_length': 100},
      options: Options(validateStatus: (_) => true),
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

  Future<void> debugEmployeePermission() async {
    final userResponse = await dio.get(
      '/api/method/frappe.auth.get_logged_user',
      options: Options(validateStatus: (_) => true),
    );

    final rolesResponse = await dio.get(
      '/api/resource/User/${userResponse.data['message']}',
      queryParameters: {'fields': '["name","user_type","roles"]'},
      options: Options(validateStatus: (_) => true),
    );

    final permissionResponse = await dio.get(
      '/api/method/frappe.client.has_permission',
      queryParameters: {'doctype': 'Employee', 'ptype': 'create'},
      options: Options(validateStatus: (_) => true),
    );

    throw Exception(
      'USER => ${userResponse.data}\n\n'
      'ROLES => ${rolesResponse.data}\n\n'
      'HAS CREATE EMPLOYEE => ${permissionResponse.data}',
    );
  }
}
