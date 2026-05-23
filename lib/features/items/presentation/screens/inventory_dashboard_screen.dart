import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/items/data/models/inventory_bin_model.dart';
import 'package:erp_sales/features/items/data/models/stock_entry_model.dart';
import 'package:erp_sales/features/items/data/models/warehouse_model.dart';
import 'package:erp_sales/features/items/data/repo/create_stock_entry_repository.dart';
import 'package:erp_sales/features/items/data/repo/item_details_repository.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'package:erp_sales/features/items/data/repo/stock_entries_repository.dart';
import 'package:erp_sales/features/items/data/repo/warehouse_repository.dart';
import 'package:erp_sales/features/items/presentation/cubit/items_cubit.dart';
import 'package:erp_sales/features/items/presentation/cubit/items_state.dart';
import 'package:erp_sales/features/items/presentation/screens/create_item_screen.dart';
import 'package:erp_sales/features/items/presentation/screens/create_stock_entry_screen.dart';
import 'package:erp_sales/features/items/presentation/screens/items_screen.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import '../widgets/inventory_hero_header.dart';
import '../widgets/responsive_grid.dart';
import '../widgets/metric_card.dart';
import '../widgets/section_card.dart';
import '../widgets/action_card.dart';
import '../widgets/activity_tile.dart';
import '../widgets/dashboard_empty_state.dart';

class InventoryDashboardScreen extends StatefulWidget {
  const InventoryDashboardScreen({super.key});

  @override
  State<InventoryDashboardScreen> createState() =>
      _InventoryDashboardScreenState();
}

class _InventoryDashboardScreenState extends State<InventoryDashboardScreen> {
  bool isLoading = true;
  String? errorMessage;

  List<StockEntryModel> stockEntries = [];
  List<WarehouseModel> warehouses = [];
  List<InventoryBinModel> bins = [];

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final repo = context.read<StockEntriesRepository>();

      final entries = await repo.getStockEntries();
      final whs = await repo.getWarehouses();
      final loadedBins = await repo.getInventoryBins();

      if (!mounted) return;

      setState(() {
        stockEntries = entries;
        warehouses = whs;
        bins = loadedBins;
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

  @override
  Widget build(BuildContext context) {
    final itemsRepository = context.read<ItemsRepository>();

    return BlocProvider(
      create: (_) => ItemsCubit(itemsRepository)..getItems(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: RefreshIndicator(
          onRefresh: loadDashboard,
          child: BlocBuilder<ItemsCubit, ItemsState>(
            builder: (context, state) {
              if (isLoading || state is ItemsLoading) {
                return ListView(
                  children: [
                    SizedBox(height: 280),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }

              if (errorMessage != null) {
                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    const SizedBox(height: 140),
                    const Icon(
                      Icons.error_outline,
                      size: 70,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(errorMessage!, textAlign: TextAlign.center),
                  ],
                );
              }

              if (state is! ItemsSuccess) {
                return const SizedBox.shrink();
              }

              return _InventoryBody(
                items: state.items,
                stockEntries: stockEntries,
                warehouses: warehouses,
                bins: bins,
                onRefresh: loadDashboard,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _InventoryBody extends StatelessWidget {
  final List<dynamic> items;
  final List<StockEntryModel> stockEntries;
  final List<WarehouseModel> warehouses;
  final List<InventoryBinModel> bins;
  final Future<void> Function() onRefresh;

  const _InventoryBody({
    required this.items,
    required this.stockEntries,
    required this.warehouses,
    required this.bins,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final itemsRepository = context.read<ItemsRepository>();
    final itemDetailsRepository = context.read<ItemDetailsRepository>();
    final createItemRepository = context.read<ItemsRepository>();
    final createStockEntryRepository = context
        .read<CreateStockEntryRepository>();
    final warehouseRepository = context.read<WarehouseRepository>();
    final l10n = AppLocalizations.of(context)!;

    final itemStockMap = <String, double>{};
    for (final bin in bins) {
      itemStockMap.update(
        bin.itemCode,
        (value) => value + bin.actualQty,
        ifAbsent: () => bin.actualQty,
      );
    }

    final lowStockItems = items.where((item) {
      final itemCode = (item.itemCode ?? '').toString();
      final qty = itemStockMap[itemCode] ?? 0;
      return qty > 0 && qty <= 5;
    }).toList();

    final outOfStockItems = items.where((item) {
      final itemCode = (item.itemCode ?? '').toString();
      final qty = itemStockMap[itemCode] ?? 0;
      return qty <= 0;
    }).toList();

    final warehouseStockMap = <String, double>{};
    for (final bin in bins) {
      warehouseStockMap.update(
        bin.warehouse,
        (value) => value + bin.actualQty,
        ifAbsent: () => bin.actualQty,
      );
    }

    final warehouseEntries = warehouseStockMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth > 900 ? 860.0 : double.infinity;

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            const InventoryHeroHeader(),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveGrid(
                        children: [
                          MetricCard(
                            title: l10n.items,
                            value: items.length.toString(),
                            icon: Icons.inventory_2_outlined,
                            color: const Color(0xFF42A5F5),
                          ),
                          MetricCard(
                            title: l10n.warehouses,
                            value: warehouses.length.toString(),
                            icon: Icons.warehouse_outlined,
                            color: const Color(0xFF16A085),
                          ),
                          MetricCard(
                            title: l10n.lowStock,
                            value: lowStockItems.length.toString(),
                            icon: Icons.warning_amber_outlined,
                            color: const Color(0xFFF39C12),
                          ),
                          MetricCard(
                            title: l10n.outOfStock,
                            value: outOfStockItems.length.toString(),
                            icon: Icons.remove_shopping_cart_outlined,
                            color: const Color(0xFFE74C3C),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SectionCard(
                        title: l10n.quickActions,
                        child: ResponsiveActions(
                          children: [
                            ActionCard(
                              title: l10n.createItemAction,
                              subtitle: l10n.addNewProduct,
                              icon: Icons.add_box_outlined,
                              color: const Color(0xFF42A5F5),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CreateItemScreen(
                                      itemsRepository: createItemRepository,
                                    ),
                                  ),
                                );

                                if (context.mounted) {
                                  context.read<ItemsCubit>().getItems();
                                  onRefresh();
                                }
                              },
                            ),
                            ActionCard(
                              title: l10n.stockEntryAction,
                              subtitle: l10n.receiveIssueStock,
                              icon: Icons.inventory_outlined,
                              color: const Color(0xFF2ECC71),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CreateStockEntryScreen(
                                      createStockEntryRepository:
                                          createStockEntryRepository,
                                      itemsRepository: itemsRepository,
                                      warehouseRepository: warehouseRepository,
                                    ),
                                  ),
                                );

                                if (context.mounted) {
                                  context.read<ItemsCubit>().getItems();
                                  onRefresh();
                                }
                              },
                            ),
                            ActionCard(
                              title: l10n.itemsList,
                              subtitle: l10n.openProducts,
                              icon: Icons.list_alt_outlined,
                              color: const Color(0xFF9B59B6),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ItemsScreen(
                                      itemsRepository: itemsRepository,
                                      itemDetailsRepository:
                                          itemDetailsRepository,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      SectionCard(
                        title: l10n.stockByWarehouse,
                        child: warehouseEntries.isEmpty
                            ? DashboardEmptyState(
                                message: l10n.noWarehouseStockFound,
                              )
                            : Column(
                                children: warehouseEntries.take(6).map((entry) {
                                  return ActivityTile(
                                    icon: Icons.warehouse_outlined,
                                    title: entry.key,
                                    subtitle: l10n.totalQuantity,
                                    trailing: entry.value.toStringAsFixed(1),
                                    color: const Color(0xFF16A085),
                                  );
                                }).toList(),
                              ),
                      ),
                      const SizedBox(height: 18),
                      SectionCard(
                        title: l10n.lowStockItems,
                        child: lowStockItems.isEmpty
                            ? DashboardEmptyState(
                                message: l10n.noLowStockFound,
                              )
                            : Column(
                                children: lowStockItems.take(6).map((item) {
                                  final itemCode = (item.itemCode ?? '')
                                      .toString();
                                  final qty = itemStockMap[itemCode] ?? 0;

                                  return ActivityTile(
                                    icon: Icons.warning_amber_outlined,
                                    title: item.itemName ?? itemCode,
                                    subtitle: itemCode,
                                    trailing: qty.toStringAsFixed(1),
                                    color: const Color(0xFFF39C12),
                                  );
                                }).toList(),
                              ),
                      ),
                      const SizedBox(height: 18),
                      SectionCard(
                        title: l10n.recentStockMovements,
                        child: stockEntries.isEmpty
                            ? DashboardEmptyState(
                                message: l10n.noStockMovementsFound,
                              )
                            : Column(
                                children: stockEntries.take(5).map((entry) {
                                  final value = entry.totalIncomingValue > 0
                                      ? entry.totalIncomingValue
                                      : entry.totalOutgoingValue;

                                  return ActivityTile(
                                    icon: Icons.swap_vert_circle_outlined,
                                    title: entry.stockEntryType,
                                    subtitle:
                                        '${entry.name} • ${entry.postingDate}',
                                    trailing: value.toStringAsFixed(1),
                                    color: const Color(0xFF9B59B6),
                                  );
                                }).toList(),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
