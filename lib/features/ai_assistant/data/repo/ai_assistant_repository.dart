import 'package:erp_sales/features/ai_assistant/data/models/ai_sales_order_command.dart';
import 'package:erp_sales/features/ai_assistant/data/models/ai_sales_order_draft.dart';
import 'package:erp_sales/features/ai_assistant/data/remote/ai_assistant_api_service.dart';
import 'package:erp_sales/features/ai_assistant/data/remote/ai_erp_lookup_api_service.dart';
import 'package:erp_sales/features/sales_orders/data/repo/create_sales_order_repository.dart';

class AiAssistantRepository {
  final AiAssistantApiService aiApiService;
  final AiErpLookupApiService lookupApiService;
  final CreateSalesOrderRepository createSalesOrderRepository;

  AiAssistantRepository({
    required this.aiApiService,
    required this.lookupApiService,
    required this.createSalesOrderRepository,
  });

  Future<AiSalesOrderDraft> prepareSalesOrderDraft(String message) async {
    final Map<String, dynamic> json;

    try {
      json = await aiApiService.extractSalesOrderCommand(message);
    } catch (_) {
      return _handleAiFailure(message);
    }

    final action = json['action'] as String? ?? '';
    final isArabic = _isArabic(message);

    if (action == 'general_response') {
      throw AiAssistantException(
        json['response'] as String? ??
            (isArabic ? 'كيف يمكنني مساعدتك؟' : 'How can I help you?'),
        isChatReply: true,
        showToast: false,
      );
    }

    if (action == 'search_item') {
      return _handleSearchItem(json, isArabic);
    }

    if (action == 'find_customer') {
      return _handleFindCustomer(json, isArabic);
    }

    if (action == 'show_latest_sales_orders') {
      throw AiAssistantException(
        isArabic
            ? 'يمكنك عرض قائمة طلبات البيع من هنا.'
            : 'You can view the sales orders list from here.',
        actionLabel: isArabic ? 'عرض طلبات البيع' : 'View Sales Orders',
        actionType: 'sales_orders',
        showToast: false,
      );
    }

    if (action == 'create_invoice_from_sales_order') {
      final orderId = json['sales_order_id'] as String? ?? '';

      throw AiAssistantException(
        isArabic
            ? 'افتح طلب البيع لإنشاء الفاتورة: $orderId'
            : 'Open the sales order to create invoice: $orderId',
        actionLabel: isArabic ? 'فتح طلب البيع' : 'Open Sales Order',
        actionType: 'sales_order_details',
        orderId: orderId,
        showToast: false,
      );
    }

    if (action == 'create_delivery_note_from_sales_order') {
      final orderId = json['sales_order_id'] as String? ?? '';

      throw AiAssistantException(
        isArabic
            ? 'افتح طلب البيع لإنشاء مذكرة التسليم: $orderId'
            : 'Open the sales order to create delivery note: $orderId',
        actionLabel: isArabic ? 'فتح طلب البيع' : 'Open Sales Order',
        actionType: 'sales_order_details',
        orderId: orderId,
        showToast: false,
      );
    }

    final command = AiSalesOrderCommand.fromJson(json);

    _validateBasicCommand(command, isArabic);

    final customer = await _resolveCustomer(command.customer, isArabic);
    final items = await _resolveItems(command.items, isArabic);

    return AiSalesOrderDraft(
      customer: customer,
      transactionDate: command.transactionDate,
      deliveryDate: command.deliveryDate,
      items: items,
    );
  }

  Future<String> confirmCreateSalesOrder(AiSalesOrderDraft draft) {
    return createSalesOrderRepository.createSalesOrder(draft.toRequest());
  }

  Future<AiSalesOrderDraft> _handleSearchItem(
    Map<String, dynamic> json,
    bool isArabic,
  ) async {
    final query = (json['query'] as String? ?? '').trim();

    if (query.isEmpty) {
      throw AiAssistantException(
        isArabic
            ? 'ما اسم المنتج الذي تريد البحث عنه؟'
            : 'Which item should I search for?',
        isChatReply: true,
        showToast: false,
      );
    }

    final items = await lookupApiService.searchItems(query);

    if (items.isEmpty) {
      throw AiAssistantException(
        isArabic ? 'لم أجد المنتج "$query".' : 'Item "$query" was not found.',
        showToast: false,
      );
    }

    throw AiAssistantException(
      isArabic
          ? 'تم العثور على المنتج: ${items.join(', ')}'
          : 'Item found: ${items.join(', ')}',
      actionLabel: isArabic ? 'الذهاب إلى المنتجات' : 'Go to Items',
      actionType: 'items',
      showToast: false,
    );
  }

  Future<AiSalesOrderDraft> _handleFindCustomer(
    Map<String, dynamic> json,
    bool isArabic,
  ) async {
    final query = (json['query'] as String? ?? '').trim();

    if (query.isEmpty) {
      throw AiAssistantException(
        isArabic
            ? 'ما اسم العميل الذي تريد البحث عنه؟'
            : 'Which customer should I search for?',
        isChatReply: true,
        showToast: false,
      );
    }

    final customers = await lookupApiService.searchCustomers(query);

    if (customers.isEmpty) {
      throw AiAssistantException(
        isArabic
            ? 'لم أجد العميل "$query".'
            : 'Customer "$query" was not found.',
        showToast: false,
      );
    }

    throw AiAssistantException(
      isArabic
          ? 'تم العثور على العميل: ${customers.join(', ')}'
          : 'Customer found: ${customers.join(', ')}',
      actionLabel: isArabic ? 'الذهاب إلى العملاء' : 'Go to Customers',
      actionType: 'customers',
      showToast: false,
    );
  }

  void _validateBasicCommand(AiSalesOrderCommand command, bool isArabic) {
    if (command.action != 'create_sales_order') {
      throw AiAssistantException(
        isArabic
            ? 'هذا الأمر غير مدعوم حاليًا.'
            : 'This action is not supported yet.',
        isChatReply: true,
        showToast: false,
      );
    }

    if (command.customer.trim().isEmpty) {
      throw AiAssistantException(
        isArabic
            ? 'ما اسم العميل الذي تريد إنشاء الطلب له؟'
            : 'Which customer should I create the sales order for?',
        isChatReply: true,
        showToast: false,
      );
    }

    if (command.items.isEmpty) {
      throw AiAssistantException(
        isArabic
            ? 'تمام، ما هو الصنف المطلوب في هذا الطلب؟'
            : 'Sure, which item should I add to this sales order?',
        isChatReply: true,
        showToast: false,
      );
    }

    if (command.transactionDate.trim().isEmpty ||
        command.deliveryDate.trim().isEmpty) {
      throw AiAssistantException(
        isArabic
            ? 'تاريخ الطلب أو تاريخ التسليم غير واضح.'
            : 'The transaction date or delivery date is missing.',
        isChatReply: true,
        showToast: false,
      );
    }
  }

  Future<String> _resolveCustomer(String input, bool isArabic) async {
    final customer = input.trim();

    final exists = await lookupApiService.customerExists(customer);

    if (exists) return customer;

    final suggestions = await lookupApiService.searchCustomers(customer);

    if (suggestions.isEmpty) {
      throw AiAssistantException(
        isArabic
            ? 'لم أجد العميل "$customer". يمكنك إنشاء عميل جديد أولًا.'
            : 'Customer "$customer" was not found. You can create a new customer first.',
        actionLabel: isArabic ? 'الذهاب إلى العملاء' : 'Go to Customers',
        actionType: 'customers',
        showToast: false,
      );
    }

    throw AiAssistantException(
      isArabic
          ? 'لم أجد العميل "$customer". هل تقصد: ${suggestions.join(', ')}؟'
          : 'Customer "$customer" was not found. Did you mean: ${suggestions.join(', ')}?',
      suggestions: suggestions,
      actionLabel: isArabic ? 'الذهاب إلى العملاء' : 'Go to Customers',
      actionType: 'customers',
      showToast: false,
    );
  }

  Future<List<AiSalesOrderDraftItem>> _resolveItems(
    List<AiSalesOrderItemCommand> items,
    bool isArabic,
  ) async {
    final result = <AiSalesOrderDraftItem>[];

    for (final item in items) {
      if (item.itemCode.trim().isEmpty) {
        throw AiAssistantException(
          isArabic ? 'ما اسم الصنف؟' : 'Which item should I add?',
          isChatReply: true,
          showToast: false,
        );
      }

      if (item.qty <= 0) {
        throw AiAssistantException(
          isArabic
              ? 'الكمية يجب أن تكون أكبر من صفر.'
              : 'Quantity must be greater than zero.',
          isChatReply: true,
          showToast: false,
        );
      }

      if (item.rate < 0) {
        throw AiAssistantException(
          isArabic
              ? 'السعر لا يمكن أن يكون أقل من صفر.'
              : 'Rate cannot be negative.',
          isChatReply: true,
          showToast: false,
        );
      }

      final itemCode = await lookupApiService.getItemCode(item.itemCode);

      if (itemCode == null) {
        final suggestions = await lookupApiService.searchItems(item.itemCode);

        if (suggestions.isEmpty) {
          throw AiAssistantException(
            isArabic
                ? 'لم أجد الصنف "${item.itemCode}". يمكنك إنشاء صنف جديد أولًا.'
                : 'Item "${item.itemCode}" was not found. You can create a new item first.',
            actionLabel: isArabic ? 'الذهاب إلى المنتجات' : 'Go to Items',
            actionType: 'items',
            showToast: false,
          );
        }

        throw AiAssistantException(
          isArabic
              ? 'لم أجد الصنف "${item.itemCode}". هل تقصد: ${suggestions.join(', ')}؟'
              : 'Item "${item.itemCode}" was not found. Did you mean: ${suggestions.join(', ')}?',
          suggestions: suggestions,
          actionLabel: isArabic ? 'الذهاب إلى المنتجات' : 'Go to Items',
          actionType: 'items',
          showToast: false,
        );
      }

      result.add(
        AiSalesOrderDraftItem(
          itemCode: itemCode,
          qty: item.qty,
          rate: item.rate,
        ),
      );
    }

    return result;
  }

  Future<AiSalesOrderDraft> _handleAiFailure(String message) async {
    final isArabic = _isArabic(message);

    throw AiAssistantException(
      isArabic
          ? 'حدث خطأ مؤقت في الاتصال بالذكاء الاصطناعي. حاول مرة أخرى بعد قليل.'
          : 'Temporary AI connection issue. Please try again in a moment.',
      isChatReply: true,
      showToast: false,
    );
  }

  bool _isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}

class AiAssistantException implements Exception {
  final String message;
  final List<String> suggestions;
  final bool isChatReply;
  final String? actionLabel;
  final String? actionType;
  final String? orderId;
  final bool showToast;

  const AiAssistantException(
    this.message, {
    this.suggestions = const [],
    this.isChatReply = false,
    this.actionLabel,
    this.actionType,
    this.orderId,
    this.showToast = true,
  });

  @override
  String toString() => message;
}
