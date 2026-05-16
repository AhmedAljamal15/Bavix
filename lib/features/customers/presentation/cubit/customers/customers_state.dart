import 'package:equatable/equatable.dart';
import 'package:erp_sales/features/customers/data/models/customer_model.dart';

abstract class CustomersState extends Equatable {
  const CustomersState();

  @override
  List<Object?> get props => [];
}

class CustomersInitial extends CustomersState {
  const CustomersInitial();
}

class CustomersLoading extends CustomersState {
  const CustomersLoading();
}

class CustomersSuccess extends CustomersState {
  final List<CustomerModel> customers;

  const CustomersSuccess(this.customers);

  @override
  List<Object?> get props => [customers];
}

class CustomersError extends CustomersState {
  final String message;

  const CustomersError(this.message);

  @override
  List<Object?> get props => [message];
}
