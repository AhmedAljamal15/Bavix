import 'package:dio/dio.dart';
import 'package:erp_sales/features/sales_orders/data/models/sales_invoice_details_model.dart';

class SalesInvoiceDetailsApiService {
  final Dio dio;

  SalesInvoiceDetailsApiService(this.dio);

  Future<SalesInvoiceDetailsModel> getSalesInvoiceDetails(String invoiceId) async {
    final response = await dio.get('/api/resource/Sales Invoice/$invoiceId');
    return SalesInvoiceDetailsModel.fromJson(response.data['data']);
  }
}