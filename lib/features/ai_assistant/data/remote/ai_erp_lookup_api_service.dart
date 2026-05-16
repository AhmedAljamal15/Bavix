import 'package:dio/dio.dart';

class AiErpLookupApiService {
  final Dio dio;

  AiErpLookupApiService(this.dio);

  Future<String?> getItemCode(String input) async {
    final suggestions = await searchItems(input);
    if (suggestions.isEmpty) return null;

    final value = input.trim().toLowerCase();

    final exact = suggestions.firstWhere(
      (item) => item.toLowerCase() == value,
      orElse: () => suggestions.first,
    );

    return exact;
  }

  Future<List<String>> searchItems(String input) async {
    final value = input.trim();

    if (value.isEmpty) return [];

    final response = await dio.get(
      '/api/resource/Item',
      queryParameters: {
        'fields': '["name","item_code","item_name"]',
        'filters': '[["disabled","=",0]]',
        'or_filters':
            '[["name","like","%$value%"],["item_code","like","%$value%"],["item_name","like","%$value%"]]',
        'limit_page_length': 10,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    final normalizedValue = value.toLowerCase();

    final exactMatches = data.where((e) {
      final item = e as Map<String, dynamic>;
      final name = (item['name'] ?? '').toString().toLowerCase();
      final itemCode = (item['item_code'] ?? '').toString().toLowerCase();
      final itemName = (item['item_name'] ?? '').toString().toLowerCase();

      return name == normalizedValue ||
          itemCode == normalizedValue ||
          itemName == normalizedValue;
    }).toList();

    if (exactMatches.isNotEmpty) {
      return exactMatches.map((e) {
        final item = e as Map<String, dynamic>;
        return (item['item_code'] ?? item['name'] ?? item['item_name'])
            .toString();
      }).toList();
    }

    return [];
  }

  Future<bool> customerExists(String customer) async {
    final response = await dio.get(
      '/api/resource/Customer/$customer',
      options: Options(validateStatus: (_) => true),
    );

    return response.statusCode == 200;
  }

  Future<List<String>> searchCustomers(String input) async {
    final value = input.trim();

    if (value.isEmpty) return [];

    final response = await dio.get(
      '/api/resource/Customer',
      queryParameters: {
        'fields': '["name","customer_name"]',
        'or_filters':
            '[["name","like","%$value%"],["customer_name","like","%$value%"]]',
        'limit_page_length': 10,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    final normalizedValue = value.toLowerCase();

    final exactMatches = data.where((e) {
      final customer = e as Map<String, dynamic>;
      final name = (customer['name'] ?? '').toString().toLowerCase();
      final customerName = (customer['customer_name'] ?? '')
          .toString()
          .toLowerCase();

      return name == normalizedValue || customerName == normalizedValue;
    }).toList();

    if (exactMatches.isNotEmpty) {
      return exactMatches.map((e) {
        final customer = e as Map<String, dynamic>;
        return (customer['name'] ?? customer['customer_name']).toString();
      }).toList();
    }

    return [];
  }

  Future<List<String>> getLatestCustomers() async {
    final response = await dio.get(
      '/api/resource/Customer',
      queryParameters: {
        'fields': '["name","customer_name"]',
        'limit_page_length': 5,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data.map((e) {
      final customer = e as Map<String, dynamic>;
      return (customer['name'] ?? customer['customer_name']).toString();
    }).toList();
  }

  Future<List<String>> getLatestItems() async {
    final response = await dio.get(
      '/api/resource/Item',
      queryParameters: {
        'fields': '["name","item_code","item_name"]',
        'filters': '[["disabled","=",0]]',
        'limit_page_length': 5,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data.map((e) {
      final item = e as Map<String, dynamic>;
      return (item['item_code'] ?? item['name'] ?? item['item_name'])
          .toString();
    }).toList();
  }
}
