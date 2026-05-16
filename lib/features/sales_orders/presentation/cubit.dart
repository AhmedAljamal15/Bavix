import 'package:erp_sales/features/sales_orders/data/repo/delivery_notes_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoices_list_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/sales_orders/data/models/create_delivery_note_request.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_repository.dart';
import 'delivery_note_state.dart';
import 'cubit/sales_invoice_state.dart';

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

class SalesInvoicesCubit extends Cubit<SalesInvoicesState> {
  final SalesInvoicesListRepository repository;

  SalesInvoicesCubit(this.repository) : super(const SalesInvoicesInitial());

  Future<void> getSalesInvoices() async {
    emit(const SalesInvoicesLoading());

    try {
      final invoices = await repository.getSalesInvoices();
      emit(SalesInvoicesSuccess(invoices));
    } catch (e) {
      emit(SalesInvoicesError(e.toString()));
    }
  }
}
