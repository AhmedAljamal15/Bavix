import 'package:equatable/equatable.dart';
import 'package:erp_sales/features/sales_orders/data/models/sales_order_model.dart';

abstract class SalesOrdersState extends Equatable {
  const SalesOrdersState();

  @override
  List<Object?> get props => [];
}

class SalesOrdersInitial extends SalesOrdersState {
  const SalesOrdersInitial();
}

class SalesOrdersLoading extends SalesOrdersState {
  const SalesOrdersLoading();
}

class SalesOrdersSuccess extends SalesOrdersState {
  final List<SalesOrderModel> orders;

  const SalesOrdersSuccess(this.orders);

  @override
  List<Object?> get props => [orders];
}

class SalesOrdersError extends SalesOrdersState {
  final String message;

  const SalesOrdersError(this.message);

  @override
  List<Object?> get props => [message];
}
