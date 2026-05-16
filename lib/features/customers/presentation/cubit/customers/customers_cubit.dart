import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';
import 'customers_state.dart';

class CustomersCubit extends Cubit<CustomersState> {
  final CustomersRepository repository;

  CustomersCubit(this.repository) : super(const CustomersInitial());

  Future<void> getCustomers() async {
    emit(const CustomersLoading());

    try {
      final customers = await repository.getCustomers();
      emit(CustomersSuccess(customers));
    } catch (e) {
      emit(CustomersError(e.toString()));
    }
  }
}
