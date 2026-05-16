import 'package:erp_sales/features/sales_orders/data/models/delivery_note_model.dart';
import 'package:erp_sales/features/sales_orders/data/remote/delivery_notes_list_api_service.dart';

class DeliveryNotesListRepository {
  final DeliveryNotesListApiService apiService;

  DeliveryNotesListRepository(this.apiService);

  Future<List<DeliveryNoteModel>> getDeliveryNotes() async {
    return apiService.getDeliveryNotes();
  }
}