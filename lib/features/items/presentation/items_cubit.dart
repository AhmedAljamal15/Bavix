import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  final ItemsRepository repository;

  ItemsCubit(this.repository) : super(const ItemsInitial());

  Future<void> getItems() async {
    emit(const ItemsLoading());

    try {
      final items = await repository.getItems();
      emit(ItemsSuccess(items));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }
}
