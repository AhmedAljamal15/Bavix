import 'package:dio/dio.dart';
import 'package:erp_sales/features/auth/data/models/access_request_item_model.dart';

class AccessRequestAdminApiService {
  final Dio dio;

  AccessRequestAdminApiService(this.dio);

  Future<List<AccessRequestItemModel>> getAccessRequests() async {
    final response = await dio.get(
      '/api/resource/Lead',
      queryParameters: {
        'fields': '["name","lead_name","email_id","status","owner"]',
        'order_by': 'creation desc',
        'limit_page_length': 100,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data
        .map((e) => AccessRequestItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateAccessRequestStatus({
    required String requestId,
    required String status,
  }) async {
    final response = await dio.put(
      '/api/resource/Lead/$requestId',
      data: {'status': status},
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }
  }
}
