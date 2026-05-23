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
import '../cubit/create_stock_entry_cubit.dart';
import '../cubit/create_stock_entry_state.dart';
import '../widgets/create_item_top_bar.dart';
import '../widgets/stock_entry_hero_card.dart';
import '../widgets/form_card.dart';
import '../widgets/premium_dropdown.dart';
import '../widgets/premium_number_field.dart';
import '../widgets/stock_entry_summary_card.dart';
import '../widgets/stock_entry_error_view.dart';

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
          child: StockEntryErrorView(
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
          AppToast.success(
            AppLocalizations.of(
              context,
            )!.stockEntryCreated(state.stockEntryName),
          );
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
                    CreateItemTopBar(
                      title: AppLocalizations.of(context)!.createStockEntry,
                      onBack: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 18),
                    StockEntryHeroCard(
                      title: 'Material Receipt',
                      subtitle:
                          'Create a stock entry to increase warehouse quantity.',
                      itemName: selectedItem?.itemName ?? '-',
                      warehouseName: selectedWarehouse?.name ?? '-',
                    ),
                    const SizedBox(height: 18),
                    FormCard(
                      child: Column(
                        children: [
                          PremiumDropdown<ItemModel>(
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
                          PremiumDropdown<WarehouseModel>(
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
                          PremiumNumberField(
                            controller: quantityController,
                            label: AppLocalizations.of(context)!.qtyLabel,
                            icon: Icons.production_quantity_limits_rounded,
                          ),
                          const SizedBox(height: 16),
                          PremiumNumberField(
                            controller: basicRateController,
                            label: AppLocalizations.of(context)!.basicRate,
                            icon: Icons.payments_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    StockEntrySummaryCard(
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
                  isSubmitting
                      ? 'Creating...'
                      : AppLocalizations.of(context)!.createStockEntry,
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
