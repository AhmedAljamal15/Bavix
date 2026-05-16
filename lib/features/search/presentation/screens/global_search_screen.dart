import 'package:erp_sales/core/constants/app_constants.dart';
import 'package:erp_sales/core/widgets/premium_widgets.dart';
import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';
import 'package:erp_sales/features/customers/presentation/screens/customers_screen.dart';
import 'package:erp_sales/features/items/data/repo/item_details_repository.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'package:erp_sales/features/items/presentation/screens/items_screen.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_notes_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoices_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_order_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_orders_list_repository.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/delivery_note_details_screen.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_invoice_details_screen.dart';
import 'package:erp_sales/features/sales_orders/presentation/screens/sales_order_details_screen.dart';
import 'package:erp_sales/features/search/data/models/global_search_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController searchController = TextEditingController();

  bool isLoading = true;
  String? errorMessage;

  List<dynamic> customers = [];
  List<dynamic> items = [];
  List<dynamic> salesOrders = [];
  List<dynamic> salesInvoices = [];
  List<dynamic> deliveryNotes = [];

  List<GlobalSearchResultModel> results = [];
  GlobalSearchResultType? selectedType;

  @override
  void initState() {
    super.initState();
    loadSources();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadSources() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedCustomers = await context
          .read<CustomersRepository>()
          .getCustomers();
      final loadedItems = await context.read<ItemsRepository>().getItems();
      final loadedSalesOrders = await context
          .read<SalesOrdersListRepository>()
          .getSalesOrders();
      final loadedSalesInvoices = await context
          .read<SalesInvoicesListRepository>()
          .getSalesInvoices();
      final loadedDeliveryNotes = await context
          .read<DeliveryNotesListRepository>()
          .getDeliveryNotes();

      if (!mounted) return;

      setState(() {
        customers = loadedCustomers;
        items = loadedItems;
        salesOrders = loadedSalesOrders;
        salesInvoices = loadedSalesInvoices;
        deliveryNotes = loadedDeliveryNotes;
        isLoading = false;
      });

      _performSearch(searchController.text.trim());
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    _performSearch(searchController.text.trim());
  }

  void _changeFilter(GlobalSearchResultType? type) {
    setState(() {
      selectedType = type;
    });
    _performSearch(searchController.text.trim());
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        results = [];
      });
      return;
    }

    final q = query.toLowerCase();
    final allResults = <GlobalSearchResultModel>[];

    for (final customer in customers) {
      final customerName = (customer.customerName ?? '').toString();
      final customerId = (customer.name ?? '').toString();
      final customerType = (customer.customerType ?? '').toString();

      if (customerName.toLowerCase().contains(q) ||
          customerId.toLowerCase().contains(q) ||
          customerType.toLowerCase().contains(q)) {
        allResults.add(
          GlobalSearchResultModel(
            type: GlobalSearchResultType.customer,
            id: customerId,
            title: customerName.isEmpty ? customerId : customerName,
            subtitle: customerId,
            trailing: customerType,
          ),
        );
      }
    }

    for (final item in items) {
      final itemName = (item.itemName ?? '').toString();
      final itemCode = (item.itemCode ?? '').toString();
      final itemGroup = (item.itemGroup ?? '').toString();

      if (itemName.toLowerCase().contains(q) ||
          itemCode.toLowerCase().contains(q) ||
          itemGroup.toLowerCase().contains(q)) {
        allResults.add(
          GlobalSearchResultModel(
            type: GlobalSearchResultType.item,
            id: itemCode,
            title: itemName.isEmpty ? itemCode : itemName,
            subtitle: itemCode,
            trailing: itemGroup,
          ),
        );
      }
    }

    for (final order in salesOrders) {
      final orderId = (order.name ?? '').toString();
      final customer = (order.customer ?? '').toString();
      final status = (order.status ?? '').toString();

      if (orderId.toLowerCase().contains(q) ||
          customer.toLowerCase().contains(q) ||
          status.toLowerCase().contains(q)) {
        allResults.add(
          GlobalSearchResultModel(
            type: GlobalSearchResultType.salesOrder,
            id: orderId,
            title: orderId,
            subtitle: customer,
            trailing: status,
          ),
        );
      }
    }

    for (final invoice in salesInvoices) {
      final invoiceId = (invoice.name ?? '').toString();
      final customer = (invoice.customer ?? '').toString();
      final status = (invoice.status ?? '').toString();
      final currency = (invoice.currency ?? '').toString();
      final grandTotal = '${invoice.grandTotal ?? ''} $currency'.trim();

      if (invoiceId.toLowerCase().contains(q) ||
          customer.toLowerCase().contains(q) ||
          status.toLowerCase().contains(q)) {
        allResults.add(
          GlobalSearchResultModel(
            type: GlobalSearchResultType.salesInvoice,
            id: invoiceId,
            title: invoiceId,
            subtitle: customer,
            trailing: grandTotal.isEmpty ? status : grandTotal,
          ),
        );
      }
    }

    for (final note in deliveryNotes) {
      final noteId = (note.name ?? '').toString();
      final customer = (note.customer ?? '').toString();
      final status = (note.status ?? '').toString();

      if (noteId.toLowerCase().contains(q) ||
          customer.toLowerCase().contains(q) ||
          status.toLowerCase().contains(q)) {
        allResults.add(
          GlobalSearchResultModel(
            type: GlobalSearchResultType.deliveryNote,
            id: noteId,
            title: noteId,
            subtitle: customer,
            trailing: status,
          ),
        );
      }
    }

    final filtered = selectedType == null
        ? allResults
        : allResults.where((r) => r.type == selectedType).toList();

    setState(() {
      results = filtered;
    });
  }

  void _openResult(GlobalSearchResultModel result) {
    switch (result.type) {
      case GlobalSearchResultType.customer:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomersScreen(
              customersRepository: context.read<CustomersRepository>(),
            ),
          ),
        );
        break;

      case GlobalSearchResultType.item:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItemsScreen(
              itemsRepository: context.read<ItemsRepository>(),
              itemDetailsRepository: context.read<ItemDetailsRepository>(),
            ),
          ),
        );
        break;

      case GlobalSearchResultType.salesOrder:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SalesOrderDetailsScreen(
              orderId: result.id,
              repository: context.read<SalesOrderDetailsRepository>(),
              deliveryNoteRepository: context.read<DeliveryNoteRepository>(),
              salesInvoiceRepository: context.read<SalesInvoiceRepository>(),
            ),
          ),
        );
        break;

      case GlobalSearchResultType.salesInvoice:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SalesInvoiceDetailsScreen(
              invoiceId: result.id,
              repository: context.read<SalesInvoiceDetailsRepository>(),
            ),
          ),
        );
        break;

      case GlobalSearchResultType.deliveryNote:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DeliveryNoteDetailsScreen(
              noteId: result.id,
              repository: context.read<DeliveryNoteDetailsRepository>(),
            ),
          ),
        );
        break;
    }
  }

  IconData _iconForType(GlobalSearchResultType type) {
    switch (type) {
      case GlobalSearchResultType.customer:
        return Icons.people_outline;
      case GlobalSearchResultType.item:
        return Icons.inventory_2_outlined;
      case GlobalSearchResultType.salesOrder:
        return Icons.assignment_outlined;
      case GlobalSearchResultType.salesInvoice:
        return Icons.receipt_long_outlined;
      case GlobalSearchResultType.deliveryNote:
        return Icons.local_shipping_outlined;
    }
  }

  Color _colorForType(GlobalSearchResultType type) {
    switch (type) {
      case GlobalSearchResultType.customer:
        return const Color(0xFF2ECC71);
      case GlobalSearchResultType.item:
        return const Color(0xFF42A5F5);
      case GlobalSearchResultType.salesOrder:
        return const Color(0xFFE74C3C);
      case GlobalSearchResultType.salesInvoice:
        return const Color(0xFF9B59B6);
      case GlobalSearchResultType.deliveryNote:
        return const Color(0xFFF39C12);
    }
  }

  String _labelForType(GlobalSearchResultType type) {
    switch (type) {
      case GlobalSearchResultType.customer:
        return 'Customer';
      case GlobalSearchResultType.item:
        return 'Item';
      case GlobalSearchResultType.salesOrder:
        return 'Order';
      case GlobalSearchResultType.salesInvoice:
        return 'Invoice';
      case GlobalSearchResultType.deliveryNote:
        return 'Delivery';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: loadSources,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _SearchHero(
              controller: searchController,
              onBack: () => Navigator.pop(context),
              onClear: () {
                searchController.clear();
                _performSearch('');
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: _FilterBar(
                selectedType: selectedType,
                onChanged: _changeFilter,
              ),
            ),
            const SizedBox(height: 14),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: List.generate(
            5,
            (index) => const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: SkeletonLoader(height: 92),
            ),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: ErrorStateWidget(message: errorMessage!, onRetry: loadSources),
      );
    }

    if (searchController.text.trim().isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 70),
        child: EmptyStateWidget(
          icon: Icons.manage_search_rounded,
          title: 'Search Everything',
          description:
              'Find customers, items, orders, invoices, and deliveries.',
        ),
      );
    }

    if (results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 70),
        child: EmptyStateWidget(
          icon: Icons.search_off_rounded,
          title: 'No results',
          description: 'Try another keyword or change the filter.',
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth > 900 ? 860.0 : double.infinity;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
              child: Column(
                children: results.map((result) {
                  final color = _colorForType(result.type);

                  return _SearchResultCard(
                    icon: _iconForType(result.type),
                    color: color,
                    typeLabel: _labelForType(result.type),
                    title: result.title,
                    subtitle: result.subtitle,
                    trailing: result.trailing,
                    onTap: () => _openResult(result),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SearchHero extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onClear;

  const _SearchHero({
    required this.controller,
    required this.onBack,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 48, 18, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF020617),
                  const Color(0xFF071A3D),
                  const Color(0xFF25105A),
                ]
              : [const Color(0xFFF1F5FF), Colors.white],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 16),
            color: Colors.black.withValues(alpha: .12),
          ),
        ],
      ),
      child: Column(
        children: [
          // Row(
          //   children: [
          //     IconButton(
          //       onPressed: onBack,
          //       icon: const Icon(Icons.arrow_back_ios_new_rounded),
          //     ),

          //     Text(
          //       'Search',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         fontSize: 23,
          //         fontWeight: FontWeight.w900,
          //         color: isDark ? Colors.white : const Color(0xFF111827),
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 5),

          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Search Everything',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Customers • Items • Orders • Invoices • Deliveries',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: isDark ? const Color(0xFF101A35) : Colors.white,
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: .10) : Colors.black12,
              ),
            ),
            child: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Type customer, item, order...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: onClear,
                        icon: const Icon(Icons.close_rounded),
                      ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final GlobalSearchResultType? selectedType;
  final ValueChanged<GlobalSearchResultType?> onChanged;

  const _FilterBar({required this.selectedType, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChipItem(
            label: 'All',
            selected: selectedType == null,
            onTap: () => onChanged(null),
          ),
          _FilterChipItem(
            label: 'Customers',
            selected: selectedType == GlobalSearchResultType.customer,
            onTap: () => onChanged(GlobalSearchResultType.customer),
          ),
          _FilterChipItem(
            label: 'Items',
            selected: selectedType == GlobalSearchResultType.item,
            onTap: () => onChanged(GlobalSearchResultType.item),
          ),
          _FilterChipItem(
            label: 'Orders',
            selected: selectedType == GlobalSearchResultType.salesOrder,
            onTap: () => onChanged(GlobalSearchResultType.salesOrder),
          ),
          _FilterChipItem(
            label: 'Invoices',
            selected: selectedType == GlobalSearchResultType.salesInvoice,
            onTap: () => onChanged(GlobalSearchResultType.salesInvoice),
          ),
          _FilterChipItem(
            label: 'Deliveries',
            selected: selectedType == GlobalSearchResultType.deliveryNote,
            onTap: () => onChanged(GlobalSearchResultType.deliveryNote),
          ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: selected,
        label: Text(label),
        onSelected: (_) => onTap(),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          color: selected
              ? Colors.white
              : isDark
              ? Colors.white70
              : const Color(0xFF111827),
        ),
        selectedColor: const Color(0xFF536DFE),
        backgroundColor: isDark ? const Color(0xFF101A35) : Colors.white,
        side: BorderSide(
          color: selected
              ? const Color(0xFF536DFE)
              : isDark
              ? Colors.white.withValues(alpha: .10)
              : Colors.black12,
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String typeLabel;
  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback onTap;

  const _SearchResultCard({
    required this.icon,
    required this.color,
    required this.typeLabel,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: isDark ? const Color(0xFF101A35) : Colors.white,
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  color: Colors.black.withValues(alpha: isDark ? .16 : .05),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: color.withValues(alpha: .14),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: color.withValues(alpha: .12),
                        ),
                        child: Text(
                          typeLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  Text(
                    trailing,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
