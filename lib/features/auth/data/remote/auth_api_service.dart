import 'package:dio/dio.dart';
import 'package:erp_sales/core/network/dio_factory.dart';

class AuthApiService {
  final Dio dio;

  AuthApiService(this.dio);

  Future<void> login({required String email, required String password}) async {
    await DioFactory.clearCookies();
    final response = await dio.post(
      '/api/method/login',
      data: {'usr': email, 'pwd': password},
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        validateStatus: (_) => true,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }
  }

  Future<void> logout() async {
    final response = await dio.get(
      '/api/method/logout',
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }
  }

  Future<String> getLoggedInUserEmail() async {
    final response = await dio.get(
      '/api/method/frappe.auth.get_logged_user',
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    return response.data['message'] as String;
  }

  Future<Map<String, dynamic>> getUserProfile(String email) async {
    final response = await dio.get(
      '/api/resource/User/$email',
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'];
    if (data is! Map) {
      throw Exception('Invalid user profile response');
    }

    return Map<String, dynamic>.from(data);
  }

  Future<void> customerSignUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/api/method/frappe.core.doctype.user.user.sign_up',
      data: {
        'email': email,
        'full_name': fullName,
        'redirect_to': '',
        'password': password,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    if (response.data is Map &&
        response.data['message'] is Map &&
        response.data['message']['message'] != null) {
      final msg = response.data['message']['message'].toString();
      if (msg.toLowerCase().contains('error')) {
        throw Exception(msg);
      }
    }
  }
}
