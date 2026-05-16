import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoices_list_repository.dart';
import 'sales_invoice_state.dart';

class SalesInvoicesCubit extends Cubit<SalesInvoicesState> {
  final SalesInvoicesListRepository repository;

  SalesInvoicesCubit(this.repository) : super(const SalesInvoicesInitial());

  Future<void> getSalesInvoices() async {
    emit(const SalesInvoicesLoading());

    try {
      final invoices = await repository.getSalesInvoices();
      emit(SalesInvoicesSuccess(invoices));
    } catch (e) {
      emit(SalesInvoicesError(e.toString()));
    }
  }
}
