import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

/// Premium glass morphism card widget
class GlassMorphismCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadows;

  const GlassMorphismCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? AppSpacing.paddingLg,
        decoration: BoxDecoration(
          color: backgroundColor ??
              (isDark
                      ? AppColors.glassDark.withValues(alpha: 0.72)
                      : AppColors.glassLight.withValues(alpha: 0.9)),
          borderRadius: borderRadius ?? AppRadius.borderRadiusXl,
          border: Border.all(
            color: isDark
                ? AppColors.neonBlue.withValues(alpha: 0.25)
                : AppColors.primary.withValues(alpha: 0.15),
            width: 0.8,
          ),
          boxShadow: shadows ??
              [
                BoxShadow(
                  color: isDark
                      ? AppColors.gradientGlow.withValues(alpha: 0.12)
                      : AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 28,
                  spreadRadius: -8,
                  offset: const Offset(0, 14),
                ),
              ],
          backgroundBlendMode: BlendMode.overlay,
        ),
        child: child,
      ),
    );
  }
}

/// Premium elevated card widget
class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadows;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? AppSpacing.paddingLg,
        decoration: BoxDecoration(
          color: backgroundColor ??
              (isDark
                  ? const Color(0xFF111D48)
                  : Colors.white.withValues(alpha: 0.94)),
          borderRadius: borderRadius ?? AppRadius.borderRadiusLg,
          border: Border.all(
            color: isDark
                ? AppColors.neonBlue.withValues(alpha: 0.18)
                : AppColors.primary.withValues(alpha: 0.12),
            width: 0.8,
          ),
          boxShadow: shadows ??
              [
                BoxShadow(
                  color: isDark
                      ? AppColors.gradientGlow.withValues(alpha: 0.08)
                      : AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 22,
                  spreadRadius: -6,
                  offset: const Offset(0, 12),
                ),
              ],
        ),
        child: child,
      ),
    ).animate().fade(duration: 300.ms).slideY(begin: 0.1, duration: 300.ms);
  }
}

/// Premium KPI card for dashboards
class KPICard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final bool showTrend;
  final double? trendValue;
  final bool isPositive;

  const KPICard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.showTrend = false,
    this.trendValue,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trendColor = isPositive ? AppColors.success : AppColors.error;

    return PremiumCard(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      value,
                      style: AppTypography.headline3.copyWith(
                        color: isDark
                            ? AppColors.textInverse
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.secondary).withValues(alpha: 0.1),
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.secondary,
                    size: AppIconSize.lg,
                  ),
                ),
            ],
          ),
          if (subtitle != null || showTrend) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (showTrend && trendValue != null) ...[
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: trendColor,
                    size: AppIconSize.sm,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${trendValue!.toStringAsFixed(1)}%',
                    style: AppTypography.labelSmall.copyWith(
                      color: trendColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (subtitle != null)
                  Expanded(
                    child: Text(
                      subtitle!,
                      style: AppTypography.captionSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Premium app bar widget
class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? leadingWidget;

  const PremiumAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actions,
    this.showBackButton = false,
    this.leadingWidget,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTypography.title1.copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading:
          leadingWidget ??
          (showBackButton
              ? GestureDetector(
                  onTap: onBackPressed ?? () => Navigator.pop(context),
                  child: Container(
                    margin: AppSpacing.paddingMd,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                )
              : null),
      actions: actions,
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : AppColors.textPrimary,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.dark
              ? AppGradients.neonHeader
              : AppGradients.lightHeader,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -12,
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium loading skeleton widget
class SkeletonLoader extends StatelessWidget {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final baseColor = isDark ? AppColors.darkSurfaceVariant : Colors.grey[300]!;
    final highlightColor = isDark ? AppColors.darkSurface : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: borderRadius ?? AppRadius.borderRadiusSm,
        ),
      ),
    );
  }
}

/// Premium button widget
class PremiumButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final ButtonStyle? style;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const PremiumButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.style,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled && !isLoading ? onPressed : null,
      style:
          style ??
          ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.textTertiary.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusLg,
            ),
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[leadingIcon!, const SizedBox(width: 8)],
          if (isLoading)
            SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )
          else
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(color: Colors.white),
            ),
          if (trailingIcon != null && !isLoading) ...[
            const SizedBox(width: 8),
            trailingIcon!,
          ],
        ],
      ),
    );
  }
}

/// Premium empty state widget
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppIconSize.xxl,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.title1.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: AppSpacing.xl),
              PremiumButton(label: actionLabel!, onPressed: onActionPressed!),
            ],
          ],
        ),
      ),
    );
  }
}

/// Premium error state widget
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String? errorDetails;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: AppIconSize.xxl,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.title1.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            if (errorDetails != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                errorDetails!,
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            PremiumButton(label: 'Retry', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
