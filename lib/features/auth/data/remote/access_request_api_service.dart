import 'package:dio/dio.dart';
import 'package:erp_sales/features/auth/data/models/access_request.dart';

class AccessRequestApiService {
  final Dio dio;

  AccessRequestApiService(this.dio);

  Future<String> createAccessRequest(AccessRequest request) async {
    final response = await dio.post(
      '/api/resource/Lead',
      data: request.toJson(),
      options: Options(
        validateStatus: (_) => true,
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.data.toString());
    }

    return response.data['data']['name'] as String;
  }
}