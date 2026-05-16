import 'package:dio/dio.dart';
import 'package:erp_sales/features/sales_orders/data/models/delivery_note_details_model.dart';

class DeliveryNoteDetailsApiService {
  final Dio dio;

  DeliveryNoteDetailsApiService(this.dio);

  Future<DeliveryNoteDetailsModel> getDeliveryNoteDetails(String noteId) async {
    final response = await dio.get('/api/resource/Delivery Note/$noteId');
    return DeliveryNoteDetailsModel.fromJson(response.data['data']);
  }
}