import 'package:erp_sales/features/sales_orders/data/models/sales_invoice_model.dart';
import 'package:erp_sales/features/sales_orders/data/remote/sales_invoices_list_api_service.dart';

class SalesInvoicesListRepository {
  final SalesInvoicesListApiService apiService;

  SalesInvoicesListRepository(this.apiService);

  Future<List<SalesInvoiceModel>> getSalesInvoices() async {
    return apiService.getSalesInvoices();
  }
}