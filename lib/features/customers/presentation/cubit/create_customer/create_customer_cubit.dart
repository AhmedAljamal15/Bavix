import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/customers/data/models/create_customer_request.dart';
import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';

import 'create_customer_state.dart';

class CreateCustomerCubit extends Cubit<CreateCustomerState> {
  final CustomersRepository repository;

  CreateCustomerCubit(this.repository) : super(const CreateCustomerInitial());

  Future<void> createCustomer({
    required String customerName,
    required String customerType,
    required String emailId,
  }) async {
    emit(const CreateCustomerLoading());

    try {
      final request = CreateCustomerRequest(
        customerName: customerName,
        customerType: customerType,
        emailId: emailId,
      );

      await repository.createCustomer(request);
      emit(const CreateCustomerSuccess());
    } catch (e) {
      emit(CreateCustomerError(e.toString()));
    }
  }
}
