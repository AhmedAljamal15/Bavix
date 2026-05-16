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
import 'package:erp_sales/features/items/presentation/items_cubit.dart';
import 'package:erp_sales/features/items/presentation/items_state.dart';
import 'package:erp_sales/features/items/presentation/screens/create_item_screen.dart';
import 'package:erp_sales/features/items/presentation/screens/create_stock_entry_screen.dart';
import 'package:erp_sales/features/items/presentation/screens/items_screen.dart';
import 'package:erp_sales/l10n/app_localizations.dart';

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
            const _InventoryHeroHeader(),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ResponsiveGrid(
                        children: [
                          _MetricCard(
                            title: l10n.items,
                            value: items.length.toString(),
                            icon: Icons.inventory_2_outlined,
                            color: const Color(0xFF42A5F5),
                          ),
                          _MetricCard(
                            title: l10n.warehouses,
                            value: warehouses.length.toString(),
                            icon: Icons.warehouse_outlined,
                            color: const Color(0xFF16A085),
                          ),
                          _MetricCard(
                            title: l10n.lowStock,
                            value: lowStockItems.length.toString(),
                            icon: Icons.warning_amber_outlined,
                            color: const Color(0xFFF39C12),
                          ),
                          _MetricCard(
                            title: l10n.outOfStock,
                            value: outOfStockItems.length.toString(),
                            icon: Icons.remove_shopping_cart_outlined,
                            color: const Color(0xFFE74C3C),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _Section(
                        title: l10n.quickActions,
                        child: _ResponsiveActions(
                          children: [
                            _ActionCard(
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
                            _ActionCard(
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
                            _ActionCard(
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
                      _Section(
                        title: l10n.stockByWarehouse,
                        child: warehouseEntries.isEmpty
                            ? _EmptyState(
                                message: l10n.noWarehouseStockFound,
                              )
                            : Column(
                                children: warehouseEntries.take(6).map((entry) {
                                  return _ActivityTile(
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
                      _Section(
                        title: l10n.lowStockItems,
                        child: lowStockItems.isEmpty
                            ? _EmptyState(
                                message: l10n.noLowStockFound,
                              )
                            : Column(
                                children: lowStockItems.take(6).map((item) {
                                  final itemCode = (item.itemCode ?? '')
                                      .toString();
                                  final qty = itemStockMap[itemCode] ?? 0;

                                  return _ActivityTile(
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
                      _Section(
                        title: l10n.recentStockMovements,
                        child: stockEntries.isEmpty
                            ? _EmptyState(
                                message: l10n.noStockMovementsFound,
                              )
                            : Column(
                                children: stockEntries.take(5).map((entry) {
                                  final value = entry.totalIncomingValue > 0
                                      ? entry.totalIncomingValue
                                      : entry.totalOutgoingValue;

                                  return _ActivityTile(
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

class _InventoryHeroHeader extends StatelessWidget {
  const _InventoryHeroHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 34),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF020617),
                  const Color(0xFF062B33),
                  const Color(0xFF0B3B4A),
                ]
              : [const Color(0xFFEFFFFA), Colors.white],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              const Icon(Icons.warehouse_outlined, color: Color(0xFF16A085)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.inventoryDashboard,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            l10n.stockControlCenter,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.trackInventoryDescription,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;

  const _ResponsiveGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 650 ? 4 : 2;
        const spacing = 14.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}

class _ResponsiveActions extends StatelessWidget {
  final List<Widget> children;

  const _ResponsiveActions({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 700 ? 3 : 2;
        const spacing = 12.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 145,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(color: color.withValues(alpha: .20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: isDark ? .18 : .06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: .08) : Colors.black12,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: isDark ? .18 : .06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          height: 138,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: isDark ? .22 : .12),
                isDark ? const Color(0xFF0B1228) : Colors.white,
              ],
            ),
            border: Border.all(color: color.withValues(alpha: .22)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF111827),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final Color color;

  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? const Color(0xFF0B1228) : const Color(0xFFF7F8FC),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          if (trailing.isNotEmpty)
            Text(
              trailing,
              style: TextStyle(fontWeight: FontWeight.w800, color: color),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white60
                : Colors.black54,
          ),
        ),
      ),
    );
  }
}
