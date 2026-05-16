import 'package:dio/dio.dart';
import '../models/customer_model.dart';
import '../models/create_customer_request.dart';

class CustomersApiService {
  final Dio dio;

  CustomersApiService(this.dio);

  Future<List<CustomerModel>> getCustomers() async {
    final response = await dio.get(
      '/api/resource/Customer',
      queryParameters: {
        'fields':
            '["name","customer_name","customer_group","territory","customer_type"]',
      },
    );

    final List customers = response.data['data'] as List? ?? [];

    return customers
        .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  //

  Future<void> createCustomer(CreateCustomerRequest request) async {
    final response = await dio.post(
      '/api/resource/Customer',
      data: request.toJson(),
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.data.toString());
    }
  }

  Future<dynamic> getCustomerByEmail(String email) async {
    final response = await dio.get(
      '/api/resource/Customer',
      queryParameters: {
        'fields': '["name","customer_name","email_id"]',
        'filters': '[["Customer","email_id","=","$email"]]',
        'limit_page_length': 1,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    if (data.isEmpty) return null;

    return data.first;
  }
}
