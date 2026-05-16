import 'package:dio/dio.dart';
import 'package:erp_sales/features/search/data/models/global_search_result_model.dart';

class GlobalSearchApiService {
  final Dio dio;

  GlobalSearchApiService(this.dio);

  Future<List<GlobalSearchResultModel>> search(String query) async {
    final List<GlobalSearchResultModel> results = [];
    final q = query.trim();

    if (q.isEmpty) return results;

    final responses = await Future.wait([
      dio.get(
        '/api/resource/Customer',
        queryParameters: {
          'fields': '["name","customer_name","customer_type"]',
          'filters': '[["Customer","customer_name","like","%$q%"]]',
          'limit_page_length': 10,
        },
      ),
      dio.get(
        '/api/resource/Item',
        queryParameters: {
          'fields': '["name","item_name","item_group"]',
          'filters': '[["Item","item_name","like","%$q%"]]',
          'limit_page_length': 10,
        },
      ),
      dio.get(
        '/api/resource/Sales Order',
        queryParameters: {
          'fields': '["name","customer","status","grand_total"]',
          'filters': '[["Sales Order","name","like","%$q%"]]',
          'limit_page_length': 10,
        },
      ),
      dio.get(
        '/api/resource/Sales Invoice',
        queryParameters: {
          'fields': '["name","customer","status","grand_total","currency"]',
          'filters': '[["Sales Invoice","name","like","%$q%"]]',
          'limit_page_length': 10,
        },
      ),
      dio.get(
        '/api/resource/Delivery Note',
        queryParameters: {
          'fields': '["name","customer","status","grand_total"]',
          'filters': '[["Delivery Note","name","like","%$q%"]]',
          'limit_page_length': 10,
        },
      ),
    ]);

    final customers = responses[0].data['data'] as List? ?? [];
    for (final customer in customers) {
      results.add(
        GlobalSearchResultModel(
          type: GlobalSearchResultType.customer,
          id: customer['name'] ?? '',
          title: customer['customer_name'] ?? customer['name'] ?? '',
          subtitle: customer['name'] ?? '',
          trailing: customer['customer_type'] ?? '',
        ),
      );
    }

    final items = responses[1].data['data'] as List? ?? [];
    for (final item in items) {
      results.add(
        GlobalSearchResultModel(
          type: GlobalSearchResultType.item,
          id: item['name'] ?? '',
          title: item['item_name'] ?? item['name'] ?? '',
          subtitle: item['name'] ?? '',
          trailing: item['item_group'] ?? '',
        ),
      );
    }

    final orders = responses[2].data['data'] as List? ?? [];
    for (final order in orders) {
      results.add(
        GlobalSearchResultModel(
          type: GlobalSearchResultType.salesOrder,
          id: order['name'] ?? '',
          title: order['name'] ?? '',
          subtitle: order['customer'] ?? '',
          trailing: '${order['grand_total'] ?? ''}',
        ),
      );
    }

    final invoices = responses[3].data['data'] as List? ?? [];
    for (final invoice in invoices) {
      results.add(
        GlobalSearchResultModel(
          type: GlobalSearchResultType.salesInvoice,
          id: invoice['name'] ?? '',
          title: invoice['name'] ?? '',
          subtitle: invoice['customer'] ?? '',
          trailing:
              '${invoice['grand_total'] ?? ''} ${invoice['currency'] ?? ''}'.trim(),
        ),
      );
    }

    final notes = responses[4].data['data'] as List? ?? [];
    for (final note in notes) {
      results.add(
        GlobalSearchResultModel(
          type: GlobalSearchResultType.deliveryNote,
          id: note['name'] ?? '',
          title: note['name'] ?? '',
          subtitle: note['customer'] ?? '',
          trailing: '${note['grand_total'] ?? ''}',
        ),
      );
    }

    return results;
  }
}