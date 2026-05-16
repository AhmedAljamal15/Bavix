import 'package:erp_sales/core/helpers/app_toast.dart';
import 'package:erp_sales/features/ai_assistant/data/models/ai_chat_session.dart';
import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';
import 'package:erp_sales/features/customers/presentation/screens/customers_screen.dart';
import 'package:erp_sales/features/items/data/repo/item_details_repository.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'package:erp_sales/features/items/presentation/screens/items_screen.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_order_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_orders_list_repository.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_order_details_screen.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiMessageBubble extends StatelessWidget {
  final AiChatMessage message;

  const AiMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final aiColor = isDark ? const Color(0xFF141B2D) : Colors.white;

    final userGradient = const LinearGradient(
      colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
    );

    return Align(
      alignment: message.isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .82,
        ),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: message.isAi ? null : userGradient,
          color: message.isAi ? aiColor : null,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: message.isAi
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              textDirection: _isArabic(message.text)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              style: TextStyle(
                color: message.isAi
                    ? (isDark ? Colors.white : const Color(0xFF111827))
                    : Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),

            if (message.actionLabel != null) ...[
              const SizedBox(height: 14),
              Align(
                alignment: message.isAi
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (message.actionType == 'customers') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CustomersScreen(
                            customersRepository: context
                                .read<CustomersRepository>(),
                          ),
                        ),
                      );
                      return;
                    }

                    if (message.actionType == 'items') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemsScreen(
                            itemsRepository: context.read<ItemsRepository>(),
                            itemDetailsRepository: context
                                .read<ItemDetailsRepository>(),
                          ),
                        ),
                      );
                      return;
                    }

                    if (message.actionType == 'sales_orders') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SalesOrdersScreen(
                            salesOrdersListRepository: context
                                .read<SalesOrdersListRepository>(),
                            salesOrderDetailsRepository: context
                                .read<SalesOrderDetailsRepository>(),
                            deliveryNoteRepository: context
                                .read<DeliveryNoteRepository>(),
                            salesInvoiceRepository: context
                                .read<SalesInvoiceRepository>(),
                          ),
                        ),
                      );
                      return;
                    }

                    if (message.actionType == 'sales_order_details' &&
                        message.orderId != null &&
                        message.orderId!.trim().isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SalesOrderDetailsScreen(
                            orderId: message.orderId!,
                            repository: context
                                .read<SalesOrderDetailsRepository>(),
                            deliveryNoteRepository: context
                                .read<DeliveryNoteRepository>(),
                            salesInvoiceRepository: context
                                .read<SalesInvoiceRepository>(),
                          ),
                        ),
                      );
                      return;
                    }

                    AppToast.info('No action available');
                  },
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: Text(message.actionLabel!),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
