import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/items/data/models/create_stock_entry_request.dart';
import 'package:erp_sales/features/items/data/repo/create_stock_entry_repository.dart';
import 'create_stock_entry_state.dart';

class CreateStockEntryCubit extends Cubit<CreateStockEntryState> {
  final CreateStockEntryRepository repository;

  CreateStockEntryCubit(this.repository)
    : super(const CreateStockEntryInitial());

  Future<void> createStockEntry(CreateStockEntryRequest request) async {
    emit(const CreateStockEntryLoading());

    try {
      final stockEntryName = await repository.createAndSubmitStockEntry(
        request,
      );
      emit(CreateStockEntrySuccess(stockEntryName));
    } catch (e) {
      emit(CreateStockEntryError(e.toString()));
    }
  }
}
