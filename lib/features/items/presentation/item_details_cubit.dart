import 'package:bloc/bloc.dart';
import 'package:erp_sales/features/items/data/repo/item_details_repository.dart';
import 'package:erp_sales/features/items/data/models/item_model.dart';

part 'item_details_state.dart';

class ItemDetailsCubit extends Cubit<ItemDetailsState> {
  final ItemDetailsRepository repository;

  ItemDetailsCubit(this.repository) : super(const ItemDetailsInitial());

  Future<void> getItemDetails(String itemId) async {
    emit(const ItemDetailsLoading());

    try {
      final item = await repository.getItemDetails(itemId);
      emit(ItemDetailsSuccess(item));
    } catch (e) {
      emit(ItemDetailsError(e.toString()));
    }
  }
}
