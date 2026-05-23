import 'package:equatable/equatable.dart';

abstract class CreateItemState extends Equatable {
  const CreateItemState();

  @override
  List<Object?> get props => [];
}

class CreateItemInitial extends CreateItemState {
  const CreateItemInitial();
}

class CreateItemLoading extends CreateItemState {
  const CreateItemLoading();
}

class CreateItemSuccess extends CreateItemState {
  const CreateItemSuccess();
}

class CreateItemError extends CreateItemState {
  final String message;

  const CreateItemError(this.message);

  @override
  List<Object?> get props => [message];
}
