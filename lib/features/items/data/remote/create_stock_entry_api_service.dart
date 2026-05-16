import 'package:dio/dio.dart';
import 'package:erp_sales/features/items/data/models/create_stock_entry_request.dart';

class CreateStockEntryApiService {
  final Dio dio;

  CreateStockEntryApiService(this.dio);

  Future<String> createAndSubmitStockEntry(
    CreateStockEntryRequest request,
  ) async {
    final createResponse = await dio.post(
      '/api/resource/Stock Entry',
      data: request.toJson(),
      options: Options(
        validateStatus: (_) => true,
      ),
    );

    if (createResponse.statusCode != 200 && createResponse.statusCode != 201) {
      throw Exception(createResponse.data.toString());
    }

    final stockEntryName = createResponse.data['data']['name'] as String;

    final getResponse = await dio.get(
      '/api/resource/Stock Entry/$stockEntryName',
      options: Options(
        validateStatus: (_) => true,
      ),
    );

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

    if (submitResponse.statusCode != 200 &&
        submitResponse.statusCode != 201) {
      throw Exception(submitResponse.data.toString());
    }

    return stockEntryName;
  }
}