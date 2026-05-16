import 'package:dio/dio.dart';
import 'package:erp_sales/features/sales_orders/data/models/create_sales_invoice_request.dart';

class SalesInvoiceApiService {
  final Dio dio;

  SalesInvoiceApiService(this.dio);

  Future<String> createSalesInvoice(
    CreateSalesInvoiceRequest request,
  ) async {
    final payload = request.toJson();

    print('Sales Invoice payload: $payload');

    final response = await dio.post(
      '/api/resource/Sales Invoice',
      data: payload,
      options: Options(
        validateStatus: (_) => true,
      ),
    );

    print('Sales Invoice status code: ${response.statusCode}');
    print('Sales Invoice response data: ${response.data}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.data.toString());
    }

    return response.data['data']['name'] as String;
  }

  Future<void> submitSalesInvoice(String invoiceName) async {
    final getResponse = await dio.get(
      '/api/resource/Sales Invoice/$invoiceName',
      options: Options(
        validateStatus: (_) => true,
      ),
    );

    print('Get Sales Invoice status code: ${getResponse.statusCode}');
    print('Get Sales Invoice response data: ${getResponse.data}');

    if (getResponse.statusCode != 200) {
      throw Exception(getResponse.data.toString());
    }

    final doc = getResponse.data['data'];

    final submitResponse = await dio.post(
      '/api/method/frappe.client.submit',
      data: {
        'doc': doc,
      },
      options: Options(
        validateStatus: (_) => true,
      ),
    );

    print('Submit Sales Invoice status code: ${submitResponse.statusCode}');
    print('Submit Sales Invoice response data: ${submitResponse.data}');

    if (submitResponse.statusCode != 200 &&
        submitResponse.statusCode != 201) {
      throw Exception(submitResponse.data.toString());
    }
  }
}