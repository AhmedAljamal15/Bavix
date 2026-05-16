import 'package:erp_sales/features/items/data/repo/create_stock_entry_repository.dart';
import 'package:erp_sales/features/items/data/repo/item_details_repository.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'package:erp_sales/features/items/data/repo/warehouse_repository.dart';
import 'package:erp_sales/features/items/presentation/items_cubit.dart';
import 'package:erp_sales/features/items/presentation/items_state.dart';
import 'package:erp_sales/features/items/presentation/screens/create_stock_entry_screen.dart';
import 'package:erp_sales/features/items/presentation/screens/item_details_screen.dart';
import 'package:erp_sales/features/items/presentation/screens/create_item_screen.dart';
import 'package:erp_sales/core/widgets/app_action_button.dart';
import 'package:flutter/material.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../item_details_cubit.dart';

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
      floatingActionButton: _ItemsFab(
        onCreateItem: () => _navigateToCreateItem(context),
        onCreateStockEntry: () => _navigateToCreateStockEntry(context),
      ),
      body: BlocBuilder<ItemsCubit, ItemsState>(
        builder: (context, state) {
          if (state is ItemsLoading) {
            return const _ItemsLoading();
          }

          if (state is ItemsError) {
            return _ItemsError(
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
                  _ItemsHeroHeader(
                    totalItems: items.length,
                    onBack: () => Navigator.pop(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 170),
                    child: Column(
                      children: [
                        _StatsGrid(
                          children: [
                            _ItemStatCard(
                              title: l10n.totalLabel,
                              value: items.length.toString(),
                              icon: Icons.inventory_2_outlined,
                              color: const Color(0xFF42A5F5),
                            ),
                            _ItemStatCard(
                              title: l10n.stockItem,
                              value: stockItems.toString(),
                              icon: Icons.warehouse_outlined,
                              color: const Color(0xFF2ECC71),
                            ),
                            _ItemStatCard(
                              title: l10n.disabled,
                              value: disabledItems.toString(),
                              icon: Icons.block_outlined,
                              color: const Color(0xFFE74C3C),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _SearchBox(
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
                          _PremiumEmptyState(
                            icon: Icons.inventory_2_outlined,
                            title: l10n.noItemsFound,
                            message: l10n.createFirstItem,
                            actionLabel: l10n.addItem,
                            onAction: () => _navigateToCreateItem(context),
                          )
                        else if (filteredItems.isEmpty)
                          _PremiumEmptyState(
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

                              return _ItemCard(
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

class _ItemsHeroHeader extends StatelessWidget {
  final int totalItems;
  final VoidCallback onBack;

  const _ItemsHeroHeader({required this.totalItems, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 48, 18, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF020617),
                  const Color(0xFF082F49),
                  const Color(0xFF0F172A),
                ]
              : [const Color(0xFFEFF6FF), Colors.white],
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
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              const Icon(Icons.inventory_2_outlined, color: Color(0xFF42A5F5)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.items,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
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
            l10n.productControlCenter,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.manageProductCatalogDescription,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFF42A5F5).withValues(alpha: .14),
            ),
            child: Text(
              l10n.itemsLoaded(totalItems),
              style: const TextStyle(
                color: Color(0xFF42A5F5),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final List<Widget> children;

  const _StatsGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const columns = 3;
        const spacing = 10.0;
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

class _ItemStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ItemStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 118,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(color: color.withValues(alpha: .18)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: isDark ? .16 : .05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBox({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: .09) : Colors.black12,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withValues(alpha: isDark ? .14 : .05),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: l10n.searchItems,
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
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String name;
  final String code;
  final String group;
  final String uom;
  final String rate;
  final bool isStockItem;
  final bool isSalesItem;
  final bool disabled;
  final VoidCallback onTap;

  const _ItemCard({
    required this.name,
    required this.code,
    required this.group,
    required this.uom,
    required this.rate,
    required this.isStockItem,
    required this.isSalesItem,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final statusColor = disabled
        ? const Color(0xFFE74C3C)
        : const Color(0xFF2ECC71);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 13),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isDark ? const Color(0xFF101A35) : Colors.white,
            border: Border.all(color: const Color(0xFF42A5F5).withValues(alpha: .16)),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const Offset(0, 10),
                color: Colors.black.withValues(alpha: isDark ? .16 : .05),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: const Color(0xFF42A5F5).withValues(alpha: .14),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Color(0xFF42A5F5),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          code,
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
                  _Badge(
                    label: disabled ? l10n.disabled : l10n.active,
                    color: statusColor,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _InfoBox(
                      label: l10n.groupLabel,
                      value: group,
                      icon: Icons.category_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoBox(
                      label: l10n.uom,
                      value: uom,
                      icon: Icons.straighten_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _InfoBox(
                      label: l10n.rateLabel,
                      value: rate,
                      icon: Icons.sell_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoBox(
                      label: l10n.typeLabel,
                      value: isStockItem ? l10n.stockLabel : l10n.nonStock,
                      icon: Icons.warehouse_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Badge(
                    label: isStockItem ? l10n.stockItem : l10n.notStock,
                    color: isStockItem ? const Color(0xFF42A5F5) : Colors.grey,
                  ),
                  _Badge(
                    label: isSalesItem ? l10n.salesItem : l10n.notSales,
                    color: isSalesItem ? const Color(0xFF2ECC71) : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: isDark ? const Color(0xFF0B1228) : const Color(0xFFF7F8FC),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: isDark ? Colors.white54 : Colors.black45),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.withValues(alpha: .12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}

class _PremiumEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showButton;

  const _PremiumEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.showButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: isDark ? const Color(0xFF101A35) : Colors.white,
      ),
      child: Column(
        children: [
          Icon(icon, size: 54, color: const Color(0xFF42A5F5)),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
          ),
          if (actionLabel != null && onAction != null && showButton) ...[
            const SizedBox(height: 18),
            AppActionButton(
              onPressed: onAction!,
              icon: Icons.add_rounded,
              label: actionLabel!,
            ),
          ],
        ],
      ),
    );
  }
}

class _ItemsFab extends StatelessWidget {
  final VoidCallback onCreateItem;
  final VoidCallback onCreateStockEntry;

  const _ItemsFab({
    required this.onCreateItem,
    required this.onCreateStockEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          AppActionButton(
            onPressed: onCreateStockEntry,
            icon: Icons.inventory_outlined,
            label: 'Create Stock Entry',
          ),
          const SizedBox(height: 12),
          AppActionButton(
            onPressed: onCreateItem,
            icon: Icons.add_rounded,
            label: 'Add Item',
          ),
        ],
      ),
    );
  }
}

class _ItemsLoading extends StatelessWidget {
  const _ItemsLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _ItemsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ItemsError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _PremiumEmptyState(
        icon: Icons.error_outline,
        title: 'Something went wrong',
        message: message,
        actionLabel: 'Retry',
        onAction: onRetry,
      ),
    );
  }
}
