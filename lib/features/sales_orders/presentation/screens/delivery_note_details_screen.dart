import 'package:flutter/material.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_details_repository.dart';
import '../widgets/delivery_note_details_top_bar.dart';
import '../widgets/delivery_note_hero_card.dart';
import '../widgets/delivery_item_card.dart';
import '../widgets/delivery_icon_box.dart';

class DeliveryNoteDetailsScreen extends StatefulWidget {
  final String noteId;
  final DeliveryNoteDetailsRepository repository;

  const DeliveryNoteDetailsScreen({
    super.key,
    required this.noteId,
    required this.repository,
  });

  @override
  State<DeliveryNoteDetailsScreen> createState() =>
      _DeliveryNoteDetailsScreenState();
}

class _DeliveryNoteDetailsScreenState
    extends State<DeliveryNoteDetailsScreen> {
  dynamic note;
  bool isLoading = true;
  String? errorMessage;

  static const Color primary = Color(0xFF60A5FA);
  static const Color bgDark = Color(0xFF020617);

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final result = await widget.repository.getDeliveryNoteDetails(
        widget.noteId,
      );

      if (!mounted) return;

      setState(() {
        note = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF2ECC71);
      case 'draft':
        return const Color(0xFF42A5F5);
      case 'to bill':
        return primary;
      case 'cancelled':
        return const Color(0xFFE74C3C);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return Scaffold(
        backgroundColor: isDark ? bgDark : Theme.of(context).scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: isDark ? bgDark : Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      );
    }

    final statusColor = _statusColor(note.status);

    return Scaffold(
      backgroundColor: isDark ? bgDark : Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
          children: [
            DeliveryNoteDetailsTopBar(
              title: note.name,
              onBack: () => Navigator.pop(context),
              onRefresh: load,
            ),
            const SizedBox(height: 22),
            DeliveryNoteHeroCard(
              noteId: note.name,
              customerName: note.customerName,
              customer: note.customer,
              postingDate: note.postingDate,
              status: note.status,
              company: note.company,
              currency: note.currency,
              totalQty: '${note.totalQty}',
              grandTotal: '${note.grandTotal} ${note.currency}',
              statusColor: statusColor,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const DeliveryIconBox(
                  icon: Icons.inventory_2_outlined,
                  color: primary,
                ),
                const SizedBox(width: 10),
                Text(
                  'Items (${note.items.length})',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...note.items.map<Widget>(
              (item) => DeliveryItemCard(
                name: item.itemName,
                code: item.itemCode,
                qty: '${item.qty}',
                uom: item.uom,
                rate: '${item.rate}',
                amount: '${item.amount}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}