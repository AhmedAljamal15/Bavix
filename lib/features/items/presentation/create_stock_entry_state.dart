import 'package:equatable/equatable.dart';

abstract class CreateStockEntryState extends Equatable {
  const CreateStockEntryState();

  @override
  List<Object?> get props => [];
}

class CreateStockEntryInitial extends CreateStockEntryState {
  const CreateStockEntryInitial();
}

class CreateStockEntryLoading extends CreateStockEntryState {
  const CreateStockEntryLoading();
}

class CreateStockEntrySuccess extends CreateStockEntryState {
  final String stockEntryName;

  const CreateStockEntrySuccess(this.stockEntryName);

  @override
  List<Object?> get props => [stockEntryName];
}

class CreateStockEntryError extends CreateStockEntryState {
  final String message;

  const CreateStockEntryError(this.message);

  @override
  List<Object?> get props => [message];
}
