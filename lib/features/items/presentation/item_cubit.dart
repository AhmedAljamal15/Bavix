import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/items/data/models/create_item_request.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'create_item_state.dart';

class CreateItemCubit extends Cubit<CreateItemState> {
  final ItemsRepository repository;

  CreateItemCubit(this.repository) : super(const CreateItemInitial());

  Future<void> createItem({
    required String itemCode,
    required String itemName,
    required String itemGroup,
    required String stockUom,
    required String countryOfOrigin,
    required bool isStockItem,
    required bool isSalesItem,
  }) async {
    emit(const CreateItemLoading());

    try {
      final request = CreateItemRequest(
        itemCode: itemCode,
        itemName: itemName,
        itemGroup: itemGroup,
        stockUom: stockUom,
        countryOfOrigin: countryOfOrigin,
        isStockItem: isStockItem ? 1 : 0,
        isSalesItem: isSalesItem ? 1 : 0,
      );
      await repository.createItem(request);
      emit(const CreateItemSuccess());
    } catch (e) {
      emit(CreateItemError(e.toString()));
    }
  }
}
