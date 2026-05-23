import 'package:erp_sales/features/items/presentation/cubit/item_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/item_details_top_bar.dart';
import '../widgets/item_details_hero_card.dart';
import '../widgets/section_title.dart';
import '../widgets/info_grid.dart';
import '../widgets/info_cell.dart';
import '../widgets/pricing_card.dart';
import '../widgets/status_card.dart';
import '../widgets/item_skeleton_loading.dart';
import '../widgets/item_error_view.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  static const Color bgDark = Color(0xFF020617);

  @override
  void initState() {
    super.initState();
    context.read<ItemDetailsCubit>().getItemDetails(widget.itemId);
  }

  Future<void> refresh() async {
    context.read<ItemDetailsCubit>().getItemDetails(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? bgDark
          : Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
          builder: (context, state) {
            if (state is ItemDetailsLoading) {
              return const ItemSkeletonLoading();
            }

            if (state is ItemDetailsError) {
              return ItemErrorView(message: state.message, onRetry: refresh);
            }

            if (state is ItemDetailsSuccess) {
              final item = state.item;

              return RefreshIndicator(
                onRefresh: refresh,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
                  children: [
                    ItemDetailsTopBar(
                      title: 'Item Details',
                      onBack: () => Navigator.pop(context),
                      onRefresh: refresh,
                    ),
                    const SizedBox(height: 22),
                    ItemDetailsHeroCard(
                      itemName: item.itemName,
                      itemId: item.name,
                      itemCode: item.itemCode,
                      itemGroup: item.itemGroup,
                      standardRate: item.standardRate.toString(),
                      stockUom: item.stockUom,
                      disabled: item.disabled,
                    ),
                    const SizedBox(height: 20),
                    SectionTitle(
                      icon: Icons.info_outline_rounded,
                      title: 'Basic Information',
                    ),
                    const SizedBox(height: 12),
                    InfoGrid(
                      children: [
                        InfoCell(
                          icon: Icons.qr_code_rounded,
                          label: 'Code',
                          value: item.itemCode,
                        ),
                        InfoCell(
                          icon: Icons.category_outlined,
                          label: 'Group',
                          value: item.itemGroup,
                        ),
                        InfoCell(
                          icon: Icons.straighten_outlined,
                          label: 'UOM',
                          value: item.stockUom,
                        ),
                        InfoCell(
                          icon: Icons.public_outlined,
                          label: 'Origin',
                          value: item.countryOfOrigin.isEmpty
                              ? '-'
                              : item.countryOfOrigin,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    SectionTitle(
                      icon: Icons.payments_outlined,
                      title: 'Pricing',
                    ),
                    const SizedBox(height: 12),
                    PricingCard(
                      standardRate: item.standardRate.toString(),
                      stockUom: item.stockUom,
                    ),
                    const SizedBox(height: 22),
                    SectionTitle(
                      icon: Icons.verified_outlined,
                      title: 'Status & Flags',
                    ),
                    const SizedBox(height: 12),
                    StatusCard(
                      isStockItem: item.isStockItem,
                      isSalesItem: item.isSalesItem,
                      disabled: item.disabled,
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
