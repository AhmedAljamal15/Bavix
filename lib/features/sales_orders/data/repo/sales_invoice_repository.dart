import 'package:erp_sales/features/sales_orders/data/models/create_sales_invoice_request.dart';
import 'package:erp_sales/features/sales_orders/data/remote/sales_invoice_api_service.dart';

class SalesInvoiceRepository {
  final SalesInvoiceApiService apiService;

  SalesInvoiceRepository(this.apiService);

  Future<String> createSalesInvoice(
    CreateSalesInvoiceRequest request,
  ) async {
    return apiService.createSalesInvoice(request);
  }

  Future<void> submitSalesInvoice(String invoiceName) async {
    await apiService.submitSalesInvoice(invoiceName);
  }
}