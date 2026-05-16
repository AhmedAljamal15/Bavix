import 'package:erp_sales/features/sales_orders/data/models/delivery_note_details_model.dart';
import 'package:erp_sales/features/sales_orders/data/remote/delivery_note_details_api_service.dart';

class DeliveryNoteDetailsRepository {
  final DeliveryNoteDetailsApiService apiService;

  DeliveryNoteDetailsRepository(this.apiService);

  Future<DeliveryNoteDetailsModel> getDeliveryNoteDetails(String noteId) async {
    return apiService.getDeliveryNoteDetails(noteId);
  }
}