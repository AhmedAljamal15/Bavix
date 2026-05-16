import 'package:erp_sales/features/ai_assistant/data/models/ai_sales_order_draft.dart';

abstract class AiAssistantState {
  const AiAssistantState();
}

class AiAssistantInitial extends AiAssistantState {
  const AiAssistantInitial();
}

class AiAssistantLoading extends AiAssistantState {
  const AiAssistantLoading();
}

class AiAssistantDraftReady extends AiAssistantState {
  final AiSalesOrderDraft draft;

  const AiAssistantDraftReady(this.draft);
}

class AiAssistantSuccess extends AiAssistantState {
  final String message;
  final String? actionLabel;
  final String? actionType;
  final String? orderId;

  const AiAssistantSuccess(
    this.message, {
    this.actionLabel,
    this.actionType,
    this.orderId,
  });
}

class AiAssistantChatReply extends AiAssistantState {
  final String message;

  const AiAssistantChatReply(this.message);
}

class AiAssistantFailure extends AiAssistantState {
  final String error;
  final List<String> suggestions;
  final String? actionLabel;
  final String? actionType;
  final String? orderId;
  final bool showToast;

  const AiAssistantFailure(
    this.error, {
    this.suggestions = const [],
    this.actionLabel,
    this.actionType,
    this.orderId,
    this.showToast = true,
  });
}
