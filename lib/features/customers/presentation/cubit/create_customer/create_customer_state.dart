import 'package:equatable/equatable.dart';

abstract class CreateCustomerState extends Equatable {
  const CreateCustomerState();

  @override
  List<Object?> get props => [];
}

class CreateCustomerInitial extends CreateCustomerState {
  const CreateCustomerInitial();
}

class CreateCustomerLoading extends CreateCustomerState {
  const CreateCustomerLoading();
}

class CreateCustomerSuccess extends CreateCustomerState {
  const CreateCustomerSuccess();
}

class CreateCustomerError extends CreateCustomerState {
  final String message;

  const CreateCustomerError(this.message);

  @override
  List<Object?> get props => [message];
}
