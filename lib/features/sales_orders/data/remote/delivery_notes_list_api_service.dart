import 'package:dio/dio.dart';
import 'package:erp_sales/features/sales_orders/data/models/delivery_note_model.dart';

class DeliveryNotesListApiService {
  final Dio dio;

  DeliveryNotesListApiService(this.dio);

  Future<List<DeliveryNoteModel>> getDeliveryNotes() async {
    final response = await dio.get(
      '/api/resource/Delivery Note',
      queryParameters: {
        'fields': '["name","customer","posting_date","status","grand_total"]',
      },
    );

    final List notes = response.data['data'] as List? ?? [];

    return notes
        .map((e) => DeliveryNoteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}