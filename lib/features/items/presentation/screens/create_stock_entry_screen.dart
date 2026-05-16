import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/items/data/models/create_stock_entry_request.dart';
import 'package:erp_sales/features/items/data/models/item_model.dart';
import 'package:erp_sales/features/items/data/models/warehouse_model.dart';
import 'package:erp_sales/features/items/data/repo/create_stock_entry_repository.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'package:erp_sales/features/items/data/repo/warehouse_repository.dart';
import 'package:erp_sales/core/helpers/app_toast.dart';
import '../create_stock_entry_cubit.dart';
import '../create_stock_entry_state.dart';

class CreateStockEntryScreen extends StatelessWidget {
  final CreateStockEntryRepository createStockEntryRepository;
  final ItemsRepository itemsRepository;
  final WarehouseRepository warehouseRepository;

  const CreateStockEntryScreen({
    super.key,
    required this.createStockEntryRepository,
    required this.itemsRepository,
    required this.warehouseRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateStockEntryCubit(createStockEntryRepository),
      child: CreateStockEntryView(
        itemsRepository: itemsRepository,
        warehouseRepository: warehouseRepository,
      ),
    );
  }
}

class CreateStockEntryView extends StatefulWidget {
  final ItemsRepository itemsRepository;
  final WarehouseRepository warehouseRepository;

  const CreateStockEntryView({
    super.key,
    required this.itemsRepository,
    required this.warehouseRepository,
  });

  @override
  State<CreateStockEntryView> createState() => _CreateStockEntryViewState();
}

class _CreateStockEntryViewState extends State<CreateStockEntryView> {
  final quantityController = TextEditingController(text: '5');
  final basicRateController = TextEditingController(text: '1000');

  List<ItemModel> items = [];
  ItemModel? selectedItem;

  List<WarehouseModel> warehouses = [];
  WarehouseModel? selectedWarehouse;

  bool isLoading = true;
  String? loadError;

  static const Color bgDark = Color(0xFF020617);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    quantityController.dispose();
    basicRateController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final itemsResult = await widget.itemsRepository.getItems();
      final warehousesResult = await widget.warehouseRepository.getWarehouses();

      if (!mounted) return;

      setState(() {
        items = itemsResult;
        warehouses = warehousesResult;

        if (itemsResult.isNotEmpty) {
          selectedItem = itemsResult.first;
        }

        if (warehousesResult.isNotEmpty) {
          selectedWarehouse = warehousesResult.firstWhere(
            (warehouse) => warehouse.name.toLowerCase().contains('stores'),
            orElse: () => warehousesResult.first,
          );
        }

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadError = e.toString();
        isLoading = false;
      });
    }
  }

  void submit() {
    FocusScope.of(context).unfocus();

    if (selectedItem == null) {
      AppToast.error(AppLocalizations.of(context)!.pleaseSelectAnItem);
      return;
    }

    if (selectedWarehouse == null) {
      AppToast.error(AppLocalizations.of(context)!.pleaseSelectAWarehouse);
      return;
    }

    final qty = double.tryParse(quantityController.text.trim());
    final rate = double.tryParse(basicRateController.text.trim());

    if (qty == null || qty <= 0) {
      AppToast.error(AppLocalizations.of(context)!.pleaseEnterValidQuantity);
      return;
    }

    if (rate == null || rate <= 0) {
      AppToast.error(AppLocalizations.of(context)!.pleaseEnterValidBasicRate);
      return;
    }

    final request = CreateStockEntryRequest(
      stockEntryType: 'Material Receipt',
      items: [
        CreateStockEntryItemRequest(
          itemCode: selectedItem!.itemCode,
          qty: qty,
          basicRate: rate,
          targetWarehouse: selectedWarehouse!.name,
        ),
      ],
    );

    context.read<CreateStockEntryCubit>().createStockEntry(request);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return Scaffold(
        backgroundColor: isDark ? bgDark : const Color(0xFFF5F7FB),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (loadError != null) {
      return Scaffold(
        backgroundColor: isDark ? bgDark : const Color(0xFFF5F7FB),
        body: SafeArea(
          child: _ErrorView(
            title: AppLocalizations.of(context)!.createStockEntry,
            message: loadError!,
            onBack: () => Navigator.pop(context),
            onRetry: _loadData,
          ),
        ),
      );
    }

    return BlocConsumer<CreateStockEntryCubit, CreateStockEntryState>(
      listener: (context, state) {
        if (state is CreateStockEntrySuccess) {
          AppToast.success(AppLocalizations.of(context)!.stockEntryCreated(state.stockEntryName));
          Navigator.pop(context, true);
        }

        if (state is CreateStockEntryError) {
          AppToast.error(state.message);
        }
      },
      builder: (context, state) {
        final isSubmitting = state is CreateStockEntryLoading;

        return Scaffold(
          backgroundColor: isDark ? bgDark : const Color(0xFFF5F7FB),
          body: SafeArea(
            child: AbsorbPointer(
              absorbing: isSubmitting,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
                child: Column(
                  children: [
                    _TopBar(
                      title: AppLocalizations.of(context)!.createStockEntry,
                      onBack: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 18),
                    _HeroCard(
                      title: 'Material Receipt',
                      subtitle:
                          'Create a stock entry to increase warehouse quantity.',
                      itemName: selectedItem?.itemName ?? '-',
                      warehouseName: selectedWarehouse?.name ?? '-',
                    ),
                    const SizedBox(height: 18),
                    _FormCard(
                      child: Column(
                        children: [
                          _PremiumDropdown<ItemModel>(
                            label: AppLocalizations.of(context)!.itemCode,
                            value: selectedItem,
                            icon: Icons.inventory_2_outlined,
                            items: items,
                            itemLabel: (item) => item.itemName,
                            onChanged: (value) {
                              setState(() => selectedItem = value);
                            },
                          ),
                          const SizedBox(height: 16),
                          _PremiumDropdown<WarehouseModel>(
                            label: AppLocalizations.of(context)!.warehouse,
                            value: selectedWarehouse,
                            icon: Icons.store_mall_directory_outlined,
                            items: warehouses,
                            itemLabel: (warehouse) => warehouse.name,
                            onChanged: (value) {
                              setState(() => selectedWarehouse = value);
                            },
                          ),
                          const SizedBox(height: 16),
                          _PremiumNumberField(
                            controller: quantityController,
                            label: AppLocalizations.of(context)!.qtyLabel,
                            icon: Icons.production_quantity_limits_rounded,
                          ),
                          const SizedBox(height: 16),
                          _PremiumNumberField(
                            controller: basicRateController,
                            label: AppLocalizations.of(context)!.basicRate,
                            icon: Icons.payments_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _SummaryCard(
                      item: selectedItem,
                      warehouse: selectedWarehouse,
                      quantity: quantityController.text,
                      rate: basicRateController.text,
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : submit,
                icon: isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.add_rounded),
                label: Text(
                  isSubmitting ? 'Creating...' : AppLocalizations.of(context)!.createStockEntry,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _TopBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onBack,
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF101A35) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 44),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String itemName;
  final String warehouseName;

  const _HeroCard({
    required this.title,
    required this.subtitle,
    required this.itemName,
    required this.warehouseName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF101A35), const Color(0xFF0B1228)]
              : [Colors.white, const Color(0xFFEFF6FF)],
        ),
        border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: .20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: isDark ? .18 : .06),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF60A5FA).withValues(alpha: .14),
            ),
            child: const Icon(
              Icons.move_to_inbox_outlined,
              color: Color(0xFF60A5FA),
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MiniChip(
                      icon: Icons.inventory_2_outlined,
                      label: itemName,
                    ),
                    _MiniChip(
                      icon: Icons.store_mall_directory_outlined,
                      label: warehouseName,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final Widget child;

  const _FormCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: isDark ? .16 : .05),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PremiumDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final IconData icon;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;

  const _PremiumDropdown({
    required this.label,
    required this.value,
    required this.icon,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: _InputDecorations.premium(
        context: context,
        label: label,
        icon: icon,
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabel(item),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class _PremiumNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _PremiumNumberField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF111827),
        fontWeight: FontWeight.w700,
      ),
      decoration: _InputDecorations.premium(
        context: context,
        label: label,
        icon: icon,
      ),
    );
  }
}

class _InputDecorations {
  static InputDecoration premium({
    required BuildContext context,
    required String label,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InputDecoration(
      labelText: label,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 10),
        child: Icon(icon, size: 21),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      filled: true,
      fillColor: isDark ? const Color(0xFF0B1228) : const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      labelStyle: TextStyle(
        color: isDark ? Colors.white60 : Colors.black54,
        fontWeight: FontWeight.w800,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 1.5),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final ItemModel? item;
  final WarehouseModel? warehouse;
  final String quantity;
  final String rate;

  const _SummaryCard({
    required this.item,
    required this.warehouse,
    required this.quantity,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final qty = double.tryParse(quantity.trim()) ?? 0;
    final basicRate = double.tryParse(rate.trim()) ?? 0;
    final amount = qty * basicRate;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: .16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stock Entry Summary',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 14),
          _SummaryRow(label: 'Item', value: item?.itemName ?? '-'),
          _SummaryRow(label: 'Warehouse', value: warehouse?.name ?? '-'),
          _SummaryRow(label: 'Quantity', value: quantity),
          _SummaryRow(label: 'Basic Rate', value: rate),
          const Divider(height: 22),
          _SummaryRow(
            label: 'Estimated Amount',
            value: amount.toStringAsFixed(2),
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: highlight
                    ? const Color(0xFF60A5FA)
                    : isDark
                    ? Colors.white
                    : const Color(0xFF111827),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF60A5FA).withValues(alpha: .12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF60A5FA)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF60A5FA),
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.title,
    required this.message,
    required this.onBack,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
      children: [
        _TopBar(title: title, onBack: onBack),
        const SizedBox(height: 120),
        Icon(
          Icons.error_outline_rounded,
          size: 70,
          color: const Color(0xFFEF4444).withValues(alpha: .9),
        ),
        const SizedBox(height: 16),
        Text(
          'Something went wrong',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
        ),
        const SizedBox(height: 18),
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(AppLocalizations.of(context)!.retry),
        ),
      ],
    );
  }
}
