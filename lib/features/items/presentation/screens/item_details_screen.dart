import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:erp_sales/features/items/presentation/item_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  static const Color primary = Color(0xFF60A5FA);
  static const Color bgDark = Color(0xFF020617);
  static const Color cardDark = Color(0xFF101A35);

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
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? bgDark
          : Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
          builder: (context, state) {
            if (state is ItemDetailsLoading) {
              return const _SkeletonLoading();
            }

            if (state is ItemDetailsError) {
              return _ErrorView(message: state.message, onRetry: refresh);
            }

            if (state is ItemDetailsSuccess) {
              final item = state.item;

              return RefreshIndicator(
                onRefresh: refresh,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
                  children: [
                    _TopBar(
                      title: 'Item Details',
                      onBack: () => Navigator.pop(context),
                      onRefresh: refresh,
                    ),
                    const SizedBox(height: 22),
                    _HeroCard(
                      itemName: item.itemName,
                      itemId: item.name,
                      itemCode: item.itemCode,
                      itemGroup: item.itemGroup,
                      standardRate: item.standardRate.toString(),
                      stockUom: item.stockUom,
                      disabled: item.disabled,
                    ),
                    const SizedBox(height: 20),
                    _SectionTitle(
                      icon: Icons.info_outline_rounded,
                      title: 'Basic Information',
                    ),
                    const SizedBox(height: 12),
                    _InfoGrid(
                      children: [
                        _InfoCell(
                          icon: Icons.qr_code_rounded,
                          label: 'Code',
                          value: item.itemCode,
                        ),
                        _InfoCell(
                          icon: Icons.category_outlined,
                          label: 'Group',
                          value: item.itemGroup,
                        ),
                        _InfoCell(
                          icon: Icons.straighten_outlined,
                          label: 'UOM',
                          value: item.stockUom,
                        ),
                        _InfoCell(
                          icon: Icons.public_outlined,
                          label: 'Origin',
                          value: item.countryOfOrigin.isEmpty
                              ? '-'
                              : item.countryOfOrigin,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _SectionTitle(
                      icon: Icons.payments_outlined,
                      title: 'Pricing',
                    ),
                    const SizedBox(height: 12),
                    _PricingCard(
                      standardRate: item.standardRate.toString(),
                      stockUom: item.stockUom,
                    ),
                    const SizedBox(height: 22),
                    _SectionTitle(
                      icon: Icons.verified_outlined,
                      title: 'Status & Flags',
                    ),
                    const SizedBox(height: 12),
                    _StatusCard(
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

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onRefresh;

  const _TopBar({
    required this.title,
    required this.onBack,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        _CircleButton(icon: Icons.arrow_back_ios_new_rounded, onTap: onBack),
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
        _CircleButton(icon: Icons.refresh_rounded, onTap: onRefresh),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
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
          icon,
          color: isDark ? Colors.white : const Color(0xFF111827),
          size: 20,
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String itemName;
  final String itemId;
  final String itemCode;
  final String itemGroup;
  final String standardRate;
  final String stockUom;
  final bool disabled;

  const _HeroCard({
    required this.itemName,
    required this.itemId,
    required this.itemCode,
    required this.itemGroup,
    required this.standardRate,
    required this.stockUom,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = disabled
        ? const Color(0xFFEF4444)
        : const Color(0xFF22C55E);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF101A35), const Color(0xFF0B1228)]
              : [Colors.white, const Color(0xFFEFF6FF)],
        ),
        border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: .24)),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 12),
            color: Colors.black.withValues(alpha: isDark ? .18 : .06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBox(
                icon: Icons.inventory_2_outlined,
                color: const Color(0xFF60A5FA),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Inventory Item',
                  style: TextStyle(
                    color: Color(0xFF60A5FA),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _Chip(
                label: disabled ? 'Disabled' : 'Active',
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            itemName.isEmpty ? itemId : itemName,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            itemId,
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 22),
          _InfoGrid(
            children: [
              _InfoCell(
                icon: Icons.qr_code_rounded,
                label: 'Item Code',
                value: itemCode,
              ),
              _InfoCell(
                icon: Icons.category_outlined,
                label: 'Group',
                value: itemGroup,
              ),
              _InfoCell(
                icon: Icons.payments_outlined,
                label: 'Rate',
                value: standardRate,
                valueColor: const Color(0xFF60A5FA),
              ),
              _InfoCell(
                icon: Icons.straighten_outlined,
                label: 'UOM',
                value: stockUom,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(icon, color: const Color(0xFF60A5FA)),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final List<Widget> children;

  const _InfoGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (_, constraints) {
        const spacing = 10.0;
        final width = (constraints.maxWidth - spacing) / 2;

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

class _InfoCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoCell({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? const Color(0xFF020617).withValues(alpha: .65) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: .06) : Colors.black12,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF60A5FA), size: 20),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black45,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-' : value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        valueColor ?? (isDark ? Colors.white : Colors.black87),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
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

class _PricingCard extends StatelessWidget {
  final String standardRate;
  final String stockUom;

  const _PricingCard({required this.standardRate, required this.stockUom});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? _ItemDetailsScreenState.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: .18)),
      ),
      child: Row(
        children: [
          _IconBox(
            icon: Icons.payments_outlined,
            color: const Color(0xFF60A5FA),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  standardRate,
                  style: const TextStyle(
                    color: Color(0xFF60A5FA),
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Standard Rate / $stockUom',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w700,
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

class _StatusCard extends StatelessWidget {
  final bool isStockItem;
  final bool isSalesItem;
  final bool disabled;

  const _StatusCard({
    required this.isStockItem,
    required this.isSalesItem,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? _ItemDetailsScreenState.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF60A5FA).withValues(alpha: .18)),
      ),
      child: Column(
        children: [
          _FlagRow(
            title: 'Stock Item',
            subtitle: isStockItem
                ? 'This item can be tracked in stock.'
                : 'Stock tracking is disabled.',
            active: isStockItem,
            icon: Icons.inventory_2_outlined,
          ),
          const SizedBox(height: 12),
          _FlagRow(
            title: 'Sales Item',
            subtitle: isSalesItem
                ? 'This item can be used in sales.'
                : 'Sales usage is disabled.',
            active: isSalesItem,
            icon: Icons.sell_outlined,
          ),
          const SizedBox(height: 12),
          _FlagRow(
            title: 'Item Status',
            subtitle: disabled
                ? 'This item is currently disabled.'
                : 'This item is active.',
            active: !disabled,
            icon: Icons.verified_outlined,
          ),
        ],
      ),
    );
  }
}

class _FlagRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;
  final IconData icon;

  const _FlagRow({
    required this.title,
    required this.subtitle,
    required this.active,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = active ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF020617).withValues(alpha: .65)
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: .18)),
      ),
      child: Row(
        children: [
          _IconBox(icon: icon, color: color),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _Chip(label: active ? 'Yes' : 'No', color: color),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconBox({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: .14),
      ),
      child: Icon(icon, color: color),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SkeletonLoading extends StatelessWidget {
  const _SkeletonLoading();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF101A35) : Colors.white;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
      children: [
        Row(
          children: [
            _SkeletonBox(width: 44, height: 44, color: baseColor),
            const Spacer(),
            _SkeletonBox(width: 120, height: 20, color: baseColor),
            const Spacer(),
            _SkeletonBox(width: 44, height: 44, color: baseColor),
          ],
        ),
        const SizedBox(height: 22),
        _SkeletonBox(width: double.infinity, height: 260, color: baseColor),
        const SizedBox(height: 22),
        _SkeletonBox(width: 180, height: 24, color: baseColor),
        const SizedBox(height: 12),
        _SkeletonBox(width: double.infinity, height: 130, color: baseColor),
        const SizedBox(height: 22),
        _SkeletonBox(width: 140, height: 24, color: baseColor),
        const SizedBox(height: 12),
        _SkeletonBox(width: double.infinity, height: 94, color: baseColor),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: .06)
              : Colors.black12,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const SizedBox(height: 140),
        Icon(
          Icons.error_outline,
          size: 70,
          color: const Color(0xFFEF4444).withValues(alpha: .9),
        ),
        const SizedBox(height: 16),
        Text(
          'Something went wrong',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w900,
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
          label: Text(l10n.retry),
        ),
      ],
    );
  }
}
