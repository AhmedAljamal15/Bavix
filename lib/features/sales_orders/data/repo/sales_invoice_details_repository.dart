import 'package:erp_sales/features/sales_orders/data/models/sales_invoice_details_model.dart';
import 'package:erp_sales/features/sales_orders/data/remote/sales_invoice_details_api_service.dart';

class SalesInvoiceDetailsRepository {
  final SalesInvoiceDetailsApiService apiService;

  SalesInvoiceDetailsRepository(this.apiService);

  Future<SalesInvoiceDetailsModel> getSalesInvoiceDetails(String invoiceId) async {
    return apiService.getSalesInvoiceDetails(invoiceId);
  }
}