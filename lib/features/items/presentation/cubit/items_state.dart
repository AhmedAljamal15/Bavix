import 'package:equatable/equatable.dart';
import 'package:erp_sales/features/items/data/models/item_model.dart';

abstract class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object?> get props => [];
}

class ItemsInitial extends ItemsState {
  const ItemsInitial();
}

class ItemsLoading extends ItemsState {
  const ItemsLoading();
}

class ItemsSuccess extends ItemsState {
  final List<ItemModel> items;

  const ItemsSuccess(this.items);

  @override
  List<Object?> get props => [items];
}

class ItemsError extends ItemsState {
  final String message;

  const ItemsError(this.message);

  @override
  List<Object?> get props => [message];
}
