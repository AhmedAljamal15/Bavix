import 'package:dio/dio.dart';
import 'package:erp_sales/features/auth/data/models/hr_user_model.dart';

class HrUsersApiService {
  final Dio dio;

  HrUsersApiService(this.dio);

  Future<List<HrUserModel>> getUsers() async {
    final response = await dio.get(
      '/api/resource/User',
      queryParameters: {
        'fields': '["name","full_name","user_type","enabled"]',
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
        .map((e) => HrUserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}