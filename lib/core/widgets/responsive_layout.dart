import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Responsive layout helper
class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext, bool isMobile) builder;

  const ResponsiveLayout({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < AppBreakpoints.tablet;
        return builder(context, isMobile);
      },
    );
  }
}

/// Responsive grid builder
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.mainAxisSpacing = AppSpacing.lg,
    this.crossAxisSpacing = AppSpacing.lg,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = mobileColumns;
        if (constraints.maxWidth >= AppBreakpoints.desktop) {
          columns = desktopColumns;
        } else if (constraints.maxWidth >= AppBreakpoints.tablet) {
          columns = tabletColumns;
        }

        return GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: children,
        );
      },
    );
  }
}

/// Safe area widget with responsive padding
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        EdgeInsets padding = mobilePadding ?? AppSpacing.paddingLg;

        if (constraints.maxWidth >= AppBreakpoints.desktop) {
          padding = desktopPadding ?? AppSpacing.paddingXxl;
        } else if (constraints.maxWidth >= AppBreakpoints.tablet) {
          padding = tabletPadding ?? AppSpacing.paddingXl;
        }

        return Padding(padding: padding, child: child);
      },
    );
  }
}

/// Responsive text scale
extension ResponsiveTextScale on num {
  double responsiveSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = width / AppBreakpoints.tablet;
    return (this * (scale.clamp(0.8, 1.2))).toDouble();
  }
}

/// Screen size utilities
class ScreenSize {
  static Size of(BuildContext context) => MediaQuery.of(context).size;

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static bool isMobile(BuildContext context) =>
      width(context) < AppBreakpoints.tablet;

  static bool isTablet(BuildContext context) =>
      width(context) >= AppBreakpoints.tablet &&
      width(context) < AppBreakpoints.desktop;

  static bool isDesktop(BuildContext context) =>
      width(context) >= AppBreakpoints.desktop;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  static double horizontalPadding(BuildContext context) {
    final width = ScreenSize.width(context);
    if (width >= AppBreakpoints.desktop) return AppSpacing.xxxl;
    if (width >= AppBreakpoints.tablet) return AppSpacing.xl;
    return AppSpacing.lg;
  }

  static double verticalPadding(BuildContext context) {
    final width = ScreenSize.width(context);
    if (width >= AppBreakpoints.desktop) return AppSpacing.xxl;
    if (width >= AppBreakpoints.tablet) return AppSpacing.xl;
    return AppSpacing.lg;
  }
}

/// Adaptive layout for different screen sizes
class AdaptiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget? tabletLayout;
  final Widget? desktopLayout;

  const AdaptiveLayout({
    super.key,
    required this.mobileLayout,
    this.tabletLayout,
    this.desktopLayout,
  });

  @override
  Widget build(BuildContext context) {
    if (ScreenSize.isDesktop(context)) {
      return desktopLayout ?? tabletLayout ?? mobileLayout;
    } else if (ScreenSize.isTablet(context)) {
      return tabletLayout ?? mobileLayout;
    }
    return mobileLayout;
  }
}

/// Responsive widget that adapts size based on screen
class ResponsiveWidget extends StatelessWidget {
  final double mobileSize;
  final double tabletSize;
  final double desktopSize;
  final Widget Function(double size) builder;

  const ResponsiveWidget({
    super.key,
    required this.mobileSize,
    required this.tabletSize,
    required this.desktopSize,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final width = ScreenSize.width(context);
    double size = mobileSize;

    if (width >= AppBreakpoints.desktop) {
      size = desktopSize;
    } else if (width >= AppBreakpoints.tablet) {
      size = tabletSize;
    }

    return builder(size);
  }
}

/// Flexible column layout for responsive design
class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double spacing;

  const ResponsiveColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.spacing = AppSpacing.lg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1) SizedBox(height: spacing),
        ],
      ],
    );
  }
}

/// Flexible row layout for responsive design
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double spacing;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.spacing = AppSpacing.lg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i < children.length - 1) SizedBox(width: spacing),
        ],
      ],
    );
  }
}

/// Responsive safe area
class ResponsiveSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  const ResponsiveSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.horizontalPadding(context),
          vertical: ScreenSize.verticalPadding(context),
        ),
        child: child,
      ),
    );
  }
}
