import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_notes_list_repository.dart';
import 'delivery_note_state.dart';

class DeliveryNotesCubit extends Cubit<DeliveryNotesState> {
  final DeliveryNotesListRepository repository;

  DeliveryNotesCubit(this.repository) : super(const DeliveryNotesInitial());

  Future<void> getDeliveryNotes() async {
    emit(const DeliveryNotesLoading());

    try {
      final notes = await repository.getDeliveryNotes();
      emit(DeliveryNotesSuccess(notes));
    } catch (e) {
      emit(DeliveryNotesError(e.toString()));
    }
  }
}
