import 'package:dio/dio.dart';
import 'package:erp_sales/features/sales_orders/data/models/sales_invoice_model.dart';

class SalesInvoicesListApiService {
  final Dio dio;

  SalesInvoicesListApiService(this.dio);

  Future<List<SalesInvoiceModel>> getSalesInvoices() async {
    final response = await dio.get(
      '/api/resource/Sales Invoice',
      queryParameters: {
        'fields':
            '["name","customer","posting_date","status","grand_total","currency"]',
      },
    );

    final List invoices = response.data['data'] as List? ?? [];

    return invoices
        .map((e) => SalesInvoiceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}