part of 'item_details_cubit.dart';

abstract class ItemDetailsState {
  const ItemDetailsState();
}

class ItemDetailsInitial extends ItemDetailsState {
  const ItemDetailsInitial();
}

class ItemDetailsLoading extends ItemDetailsState {
  const ItemDetailsLoading();
}

class ItemDetailsSuccess extends ItemDetailsState {
  final ItemModel item;

  const ItemDetailsSuccess(this.item);
}

class ItemDetailsError extends ItemDetailsState {
  final String message;

  const ItemDetailsError(this.message);
}
