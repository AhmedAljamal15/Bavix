import 'package:erp_sales/features/items/data/repo/create_stock_entry_repository.dart';
import 'package:erp_sales/features/items/data/repo/item_details_repository.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'package:erp_sales/features/items/data/repo/warehouse_repository.dart';
import 'package:erp_sales/features/items/presentation/cubit/items_cubit.dart';
import 'package:erp_sales/features/items/presentation/cubit/items_state.dart';
import 'package:erp_sales/features/items/presentation/screens/create_stock_entry_screen.dart';
import 'package:erp_sales/features/items/presentation/screens/item_details_screen.dart';
import 'package:erp_sales/features/items/presentation/screens/create_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../cubit/item_details_cubit.dart';
import '../widgets/items_hero_header.dart';
import '../widgets/stats_grid.dart';
import '../widgets/item_stat_card.dart';
import '../widgets/items_search_box.dart';
import '../widgets/item_card.dart';
import '../widgets/premium_empty_state.dart';
import '../widgets/items_fab.dart';
import '../widgets/items_loading_state.dart';
import '../widgets/items_error_state.dart';

class ItemsScreen extends StatelessWidget {
  final ItemsRepository itemsRepository;
  final ItemDetailsRepository itemDetailsRepository;

  const ItemsScreen({
    super.key,
    required this.itemsRepository,
    required this.itemDetailsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ItemsCubit(itemsRepository)..getItems(),
      child: ItemsView(
        itemsRepository: itemsRepository,
        itemDetailsRepository: itemDetailsRepository,
      ),
    );
  }
}

class ItemsView extends StatefulWidget {
  final ItemsRepository itemsRepository;
  final ItemDetailsRepository itemDetailsRepository;

  const ItemsView({
    super.key,
    required this.itemsRepository,
    required this.itemDetailsRepository,
  });

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _navigateToCreateItem(BuildContext context) async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CreateItemScreen(itemsRepository: widget.itemsRepository),
      ),
    );

    if (created == true && mounted) {
      context.read<ItemsCubit>().getItems();
    }
  }

  Future<void> _navigateToCreateStockEntry(BuildContext context) async {
    final createStockEntryRepository = context
        .read<CreateStockEntryRepository>();
    final itemsRepository = context.read<ItemsRepository>();
    final warehouseRepository = context.read<WarehouseRepository>();

    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateStockEntryScreen(
          createStockEntryRepository: createStockEntryRepository,
          itemsRepository: itemsRepository,
          warehouseRepository: warehouseRepository,
        ),
      ),
    );

    if (created == true && mounted) {
      context.read<ItemsCubit>().getItems();
    }
  }

  void _openDetails(BuildContext context, dynamic item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ItemDetailsCubit(widget.itemDetailsRepository),
          child: ItemDetailsScreen(itemId: item.name),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ItemsFab(
        onCreateItem: () => _navigateToCreateItem(context),
        onCreateStockEntry: () => _navigateToCreateStockEntry(context),
      ),
      body: BlocBuilder<ItemsCubit, ItemsState>(
        builder: (context, state) {
          if (state is ItemsLoading) {
            return const ItemsLoadingState();
          }

          if (state is ItemsError) {
            return ItemsErrorState(
              message: state.message,
              onRetry: () => context.read<ItemsCubit>().getItems(),
            );
          }

          if (state is ItemsSuccess) {
            final items = state.items;

            final filteredItems = items.where((item) {
              final q = _query.toLowerCase().trim();
              if (q.isEmpty) return true;

              return item.itemName.toLowerCase().contains(q) ||
                  item.itemCode.toLowerCase().contains(q) ||
                  item.itemGroup.toLowerCase().contains(q) ||
                  item.stockUom.toLowerCase().contains(q);
            }).toList();

            final stockItems = items.where((item) => item.isStockItem).length;
            final disabledItems = items.where((item) => item.disabled).length;

            return RefreshIndicator(
              onRefresh: () => context.read<ItemsCubit>().getItems(),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ItemsHeroHeader(
                    totalItems: items.length,
                    onBack: () => Navigator.pop(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 170),
                    child: Column(
                      children: [
                        StatsGrid(
                          children: [
                            ItemStatCard(
                              title: l10n.totalLabel,
                              value: items.length.toString(),
                              icon: Icons.inventory_2_outlined,
                              color: const Color(0xFF42A5F5),
                            ),
                            ItemStatCard(
                              title: l10n.stockItem,
                              value: stockItems.toString(),
                              icon: Icons.warehouse_outlined,
                              color: const Color(0xFF2ECC71),
                            ),
                            ItemStatCard(
                              title: l10n.disabled,
                              value: disabledItems.toString(),
                              icon: Icons.block_outlined,
                              color: const Color(0xFFE74C3C),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        ItemsSearchBox(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() => _query = value);
                          },
                          onClear: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                        const SizedBox(height: 18),
                        if (items.isEmpty)
                          PremiumEmptyState(
                            icon: Icons.inventory_2_outlined,
                            title: l10n.noItemsFound,
                            message: l10n.createFirstItem,
                            actionLabel: l10n.addItem,
                            onAction: () => _navigateToCreateItem(context),
                          )
                        else if (filteredItems.isEmpty)
                          PremiumEmptyState(
                            icon: Icons.search_off_rounded,
                            title: l10n.noMatchingItems,
                            message: l10n.trySearchingItems,
                          )
                        else
                          Column(
                            children: filteredItems.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final item = entry.value;

                              return ItemCard(
                                    name: item.itemName,
                                    code: item.itemCode,
                                    group: item.itemGroup,
                                    uom: item.stockUom,
                                    rate: item.standardRate.toString(),
                                    isStockItem: item.isStockItem,
                                    isSalesItem: item.isSalesItem,
                                    disabled: item.disabled,
                                    onTap: () => _openDetails(context, item),
                                  )
                                  .animate()
                                  .fade(
                                    delay: (index * 45).ms,
                                    duration: 350.ms,
                                  )
                                  .slideY(begin: .08, duration: 350.ms);
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
