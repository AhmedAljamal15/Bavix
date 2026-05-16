import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/sales_orders/data/models/create_delivery_note_request.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_repository.dart';
import 'delivery_note_state.dart';

class DeliveryNoteCubit extends Cubit<DeliveryNoteState> {
  final DeliveryNoteRepository repository;

  DeliveryNoteCubit(this.repository) : super(const DeliveryNoteInitial());

  Future<void> createDeliveryNote(CreateDeliveryNoteRequest request) async {
    emit(const DeliveryNoteLoading());

    try {
      final deliveryNoteName = await repository.createDeliveryNote(request);
      emit(DeliveryNoteSuccess(deliveryNoteName));
    } catch (e) {
      emit(DeliveryNoteError(e.toString()));
    }
  }

  Future<void> submitDeliveryNote(String deliveryNoteName) async {
    emit(const DeliveryNoteSubmitLoading());

    try {
      await repository.submitDeliveryNote(deliveryNoteName);
      emit(const DeliveryNoteSubmitSuccess());
    } catch (e) {
      emit(DeliveryNoteError(e.toString()));
    }
  }
}
