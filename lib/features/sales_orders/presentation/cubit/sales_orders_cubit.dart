import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_orders_list_repository.dart';
import 'sales_orders_state.dart';

class SalesOrdersCubit extends Cubit<SalesOrdersState> {
  final SalesOrdersListRepository repository;

  SalesOrdersCubit(this.repository) : super(const SalesOrdersInitial());

  Future<void> getSalesOrders() async {
    emit(const SalesOrdersLoading());

    try {
      final orders = await repository.getSalesOrders();
      emit(SalesOrdersSuccess(orders));
    } catch (e) {
      emit(SalesOrdersError(e.toString()));
    }
  }
}
