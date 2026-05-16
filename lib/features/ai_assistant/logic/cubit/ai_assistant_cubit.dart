import 'package:erp_sales/features/ai_assistant/data/models/ai_sales_order_draft.dart';
import 'package:erp_sales/features/ai_assistant/data/repo/ai_assistant_repository.dart';
import 'package:erp_sales/features/ai_assistant/logic/cubit/ai_assistant_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiAssistantCubit extends Cubit<AiAssistantState> {
  final AiAssistantRepository repository;
  String? _pendingSalesOrderCustomer;


  AiAssistantCubit(this.repository) : super(const AiAssistantInitial());

  Future<void> sendMessage(String message) async {
    final originalMessage = message.trim();

    if (originalMessage.isEmpty) {
      emit(const AiAssistantFailure('Please enter a command'));
      return;
    }

    emit(const AiAssistantLoading());

    try {
      final effectiveMessage = _buildMessageWithPendingContext(originalMessage);

      final draft = await repository.prepareSalesOrderDraft(effectiveMessage);

      _pendingSalesOrderCustomer = null;

      emit(AiAssistantDraftReady(draft));
    } on AiAssistantException catch (e) {
      if (e.message.contains('ما هو الصنف') ||
          e.message.toLowerCase().contains('which item')) {
        _pendingSalesOrderCustomer = _extractCustomerFromLastMessage(
          originalMessage,
        );
      }

      if (e.isChatReply) {
        emit(AiAssistantChatReply(e.message));
        return;
      }

      emit(
        AiAssistantFailure(
          e.message,
          suggestions: e.suggestions,
          actionLabel: e.actionLabel,
          actionType: e.actionType,
          orderId: e.orderId,
          showToast: e.showToast,
        ),
      );
    } catch (e) {
      emit(AiAssistantFailure(e.toString() ));
    }
  }

  Future<void> confirmCreateSalesOrder(AiSalesOrderDraft draft) async {
    emit(const AiAssistantLoading());

    try {
      final orderName = await repository.confirmCreateSalesOrder(draft);

      emit(
        AiAssistantSuccess(
          'Sales Order created successfully: $orderName',
          actionLabel: 'Open Created Order',
          actionType: 'sales_order_details',
          orderId: orderName,
        ),
      );
    } on AiAssistantException catch (e) {
      if (e.isChatReply) {
        emit(AiAssistantChatReply(e.message));
        return;
      }

      emit(
        AiAssistantFailure(
          e.message,
          suggestions: e.suggestions,
          actionLabel: e.actionLabel,
          actionType: e.actionType,
          orderId: e.orderId,
          showToast: e.showToast,
        ),
      );
    } catch (e) {
      emit(AiAssistantFailure(e.toString()));
    }
  }


String _buildMessageWithPendingContext(String message) {
  if (_pendingSalesOrderCustomer == null) {
    return message;
  }

  return 'create sales order for customer $_pendingSalesOrderCustomer $message';
}

String? _extractCustomerFromLastMessage(String message) {
  final arabicMatch = RegExp(r'للعميل\s+([^\s]+)').firstMatch(message);
  if (arabicMatch != null) return arabicMatch.group(1);

  final englishMatch = RegExp(
    r'customer\s+([^\s]+)',
    caseSensitive: false,
  ).firstMatch(message);

  if (englishMatch != null) return englishMatch.group(1);

  return null;
}

}
