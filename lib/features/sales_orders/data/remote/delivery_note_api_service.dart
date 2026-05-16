import 'package:dio/dio.dart';
import 'package:erp_sales/features/sales_orders/data/models/create_delivery_note_request.dart';

class DeliveryNoteApiService {
  final Dio dio;

  DeliveryNoteApiService(this.dio);

  Future<String> createDeliveryNote(CreateDeliveryNoteRequest request) async {
    final payload = request.toJson();

    print('Delivery Note payload: $payload');

    final response = await dio.post(
      '/api/resource/Delivery Note',
      data: payload,
      options: Options(validateStatus: (_) => true),
    );

    print('Delivery Note status code: ${response.statusCode}');
    print('Delivery Note response data: ${response.data}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.data.toString());
    }

    return response.data['data']['name'] as String;
  }

  Future<void> submitDeliveryNote(String deliveryNoteName) async {
    final getResponse = await dio.get(
      '/api/resource/Delivery Note/$deliveryNoteName',
      options: Options(validateStatus: (_) => true),
    );

    print('Get Delivery Note status code: ${getResponse.statusCode}');
    print('Get Delivery Note response data: ${getResponse.data}');

    if (getResponse.statusCode != 200) {
      throw Exception(getResponse.data.toString());
    }

    final doc = getResponse.data['data'];

    final submitResponse = await dio.post(
      '/api/method/frappe.client.submit',
      data: {'doc': doc},
      options: Options(validateStatus: (_) => true),
    );

    print('Submit Delivery Note status code: ${submitResponse.statusCode}');
    print('Submit Delivery Note response data: ${submitResponse.data}');

    if (submitResponse.statusCode != 200 && submitResponse.statusCode != 201) {
      throw Exception(submitResponse.data.toString());
    }
  }
}
