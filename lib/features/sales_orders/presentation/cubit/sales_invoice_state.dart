import 'package:equatable/equatable.dart';
import 'package:erp_sales/features/sales_orders/data/models/sales_invoice_model.dart';

abstract class SalesInvoicesState extends Equatable {
  const SalesInvoicesState();

  @override
  List<Object?> get props => [];
}

class SalesInvoicesInitial extends SalesInvoicesState {
  const SalesInvoicesInitial();
}

class SalesInvoicesLoading extends SalesInvoicesState {
  const SalesInvoicesLoading();
}

class SalesInvoicesSuccess extends SalesInvoicesState {
  final List<SalesInvoiceModel> invoices;

  const SalesInvoicesSuccess(this.invoices);

  @override
  List<Object?> get props => [invoices];
}

class SalesInvoicesError extends SalesInvoicesState {
  final String message;

  const SalesInvoicesError(this.message);

  @override
  List<Object?> get props => [message];
}
