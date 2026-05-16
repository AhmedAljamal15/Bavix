import 'package:equatable/equatable.dart';
import 'package:erp_sales/features/sales_orders/data/models/delivery_note_model.dart';

// ── Single DeliveryNote (create / submit) states ──────────────────────────────

abstract class DeliveryNoteState extends Equatable {
  const DeliveryNoteState();

  @override
  List<Object?> get props => [];
}

class DeliveryNoteInitial extends DeliveryNoteState {
  const DeliveryNoteInitial();
}

class DeliveryNoteLoading extends DeliveryNoteState {
  const DeliveryNoteLoading();
}

class DeliveryNoteSuccess extends DeliveryNoteState {
  final String deliveryNoteName;

  const DeliveryNoteSuccess(this.deliveryNoteName);

  @override
  List<Object?> get props => [deliveryNoteName];
}

class DeliveryNoteSubmitLoading extends DeliveryNoteState {
  const DeliveryNoteSubmitLoading();
}

class DeliveryNoteSubmitSuccess extends DeliveryNoteState {
  const DeliveryNoteSubmitSuccess();
}

class DeliveryNoteError extends DeliveryNoteState {
  final String message;

  const DeliveryNoteError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── DeliveryNotes list states ─────────────────────────────────────────────────

abstract class DeliveryNotesState extends Equatable {
  const DeliveryNotesState();

  @override
  List<Object?> get props => [];
}

class DeliveryNotesInitial extends DeliveryNotesState {
  const DeliveryNotesInitial();
}

class DeliveryNotesLoading extends DeliveryNotesState {
  const DeliveryNotesLoading();
}

class DeliveryNotesSuccess extends DeliveryNotesState {
  final List<DeliveryNoteModel> notes;

  const DeliveryNotesSuccess(this.notes);

  @override
  List<Object?> get props => [notes];
}

class DeliveryNotesError extends DeliveryNotesState {
  final String message;

  const DeliveryNotesError(this.message);

  @override
  List<Object?> get props => [message];
}
