import 'package:erp_sales/features/sales_orders/data/models/create_delivery_note_request.dart';
import 'package:erp_sales/features/sales_orders/data/remote/delivery_note_api_service.dart';

class DeliveryNoteRepository {
  final DeliveryNoteApiService apiService;

  DeliveryNoteRepository(this.apiService);

  Future<String> createDeliveryNote(
    CreateDeliveryNoteRequest request,
  ) async {
    return apiService.createDeliveryNote(request);
  }

  Future<void> submitDeliveryNote(String deliveryNoteName) async {
    await apiService.submitDeliveryNote(deliveryNoteName);
  }
}