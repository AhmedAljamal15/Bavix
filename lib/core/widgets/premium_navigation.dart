import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Premium tab bar widget with custom styling
class PremiumTabBar extends StatelessWidget {
  final List<Tab> tabs;
  final TabController controller;
  final bool isScrollable;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;

  const PremiumTabBar({
    super.key,
    required this.tabs,
    required this.controller,
    this.isScrollable = false,
    this.backgroundColor,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (isDark ? AppColors.darkSurface : AppColors.surface),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: isScrollable,
        indicatorColor: indicatorColor ?? AppColors.secondary,
        labelColor: labelColor ?? AppColors.secondary,
        unselectedLabelColor: unselectedLabelColor ?? AppColors.textTertiary,
        tabs: tabs,
        labelStyle: AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.labelMedium,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: indicatorColor ?? AppColors.secondary,
            width: 3,
          ),
        ),
      ),
    );
  }
}

/// Premium tab content widget with fade animation
class PremiumTabContent extends StatefulWidget {
  final List<Widget> children;
  final TabController controller;

  const PremiumTabContent({
    super.key,
    required this.children,
    required this.controller,
  });

  @override
  State<PremiumTabContent> createState() => _PremiumTabContentState();
}

class _PremiumTabContentState extends State<PremiumTabContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: AppDuration.fast,
      vsync: this,
    );

    widget.controller.addListener(_handleTabChange);
    _fadeController.forward();
  }

  void _handleTabChange() {
    _fadeController.reset();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    widget.controller.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeController,
      child: IndexedStack(
        index: widget.controller.index,
        children: widget.children,
      ),
    );
  }
}

/// Premium bottom navigation bar
class PremiumBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<PremiumBottomNavItem> items;
  final ValueChanged<int> onTap;
  final Color? backgroundColor;

  const PremiumBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (isDark ? AppColors.darkSurface : AppColors.surface),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: 1,
          ),
        ),
        boxShadow: AppElevation.shadowMd,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              items.length,
              (index) => _buildNavItem(
                context,
                items[index],
                index,
                index == currentIndex,
                () => onTap(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    PremiumBottomNavItem item,
    int index,
    bool isActive,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.secondary.withValues(alpha: 0.1)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              color: isActive ? AppColors.secondary : AppColors.textTertiary,
              size: AppIconSize.md,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: AppTypography.captionSmall.copyWith(
              color: isActive ? AppColors.secondary : AppColors.textTertiary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Model for bottom navigation item
class PremiumBottomNavItem {
  final IconData icon;
  final String label;

  PremiumBottomNavItem({required this.icon, required this.label});
}

/// Premium navigation rail for larger screens
class PremiumNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationRailDestination> destinations;
  final ValueChanged<int> onDestinationSelected;
  final Color? backgroundColor;

  const PremiumNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor:
          backgroundColor ??
          (isDark ? AppColors.darkSurface : AppColors.surface),
      destinations: destinations,
      labelType: NavigationRailLabelType.selected,
      indicatorColor: AppColors.secondary.withValues(alpha: 0.2),
      selectedIconTheme: IconThemeData(
        color: AppColors.secondary,
        size: AppIconSize.lg,
      ),
      unselectedIconTheme: IconThemeData(
        color: AppColors.textTertiary,
        size: AppIconSize.lg,
      ),
    );
  }
}

/// Modal bottom sheet with premium styling
Future<T?> showPremiumModalBottomSheet<T>(
  BuildContext context, {
  required Widget Function(BuildContext) builder,
  bool isDismissible = true,
  bool enableDrag = true,
  Color? backgroundColor,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor:
        backgroundColor ?? (isDark ? AppColors.darkSurface : AppColors.surface),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppRadius.xl),
        topRight: Radius.circular(AppRadius.xl),
      ),
    ),
    builder: builder,
  );
}

/// Premium dialog widget
Future<T?> showPremiumDialog<T>(
  BuildContext context, {
  required String title,
  required String content,
  String? confirmLabel,
  String? cancelLabel,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  Color? confirmColor,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showDialog<T>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLg),
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.title1.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              content,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (cancelLabel != null)
                  TextButton(
                    onPressed: () {
                      onCancel?.call();
                      Navigator.pop(context);
                    },
                    child: Text(
                      cancelLabel,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                const SizedBox(width: AppSpacing.md),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor ?? AppColors.secondary,
                  ),
                  onPressed: () {
                    onConfirm?.call();
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    confirmLabel ?? 'Confirm',
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
