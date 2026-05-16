import 'package:flutter/material.dart';

/// Premium color palette for enterprise SaaS application
/// Inspired by Stripe, Notion, Linear quality standards
class AppColors {
  // Futuristic neon blue palette
  static const Color primary = Color(0xFF3A6BFF);
  static const Color primaryLight = Color(0xFF6E8DFF);
  static const Color primaryDark = Color(0xFF1E3AA7);
  static const Color neonBlue = Color(0xFF4DA5FF);
  static const Color electricBlue = Color(0xFF2AE3FF);
  static const Color neonViolet = Color(0xFF7B61FF);

  // Secondary colors - Vibrant accent
  static const Color secondary = Color(0xFF2AE3FF);
  static const Color secondaryLight = Color(0xFF7BF1FF);
  static const Color secondaryDark = Color(0xFF1AA8C9);

  // Accent colors for various states
  static const Color success = Color(0xFF27AE60);
  static const Color successLight = Color(0xFF52BE80);
  static const Color error = Color(0xFFE74C3C);
  static const Color errorLight = Color(0xFFFADFDA);
  static const Color warning = Color(0xFFF39C12);
  static const Color warningLight = Color(0xFFFCCE5A);
  static const Color info = Color(0xFF3498DB);
  static const Color infoLight = Color(0xFFD6EAF8);

  // Neutral colors
  static const Color background = Color(0xFFF5F8FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);
  static const Color border = Color(0xFFE8ECED);
  static const Color divider = Color(0xFFE0E6ED);

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Dark mode colors
  static const Color darkBackground = Color(0xFF050A1F);
  static const Color darkSurface = Color(0xFF0E1738);
  static const Color darkSurfaceVariant = Color(0xFF192756);
  static const Color darkBorder = Color(0xFF2B3E79);

  // Glass morphism colors
  static const Color glassLight = Color(0xFFFDFEFF);
  static const Color glassDark = Color(0xFF121D43);

  // Gradient colors
  static const Color gradientStart = Color(0xFF2D52FF);
  static const Color gradientMid = Color(0xFF314FCA);
  static const Color gradientEnd = Color(0xFF061232);
  static const Color gradientGlow = Color(0xFF31D6FF);

  // Premium shadows
  static const boxShadowLight = Color(0x1F000000);
  static const boxShadowDark = Color(0x3F000000);
}

/// Premium typography system
class AppTypography {
  // Headline styles
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.2,
  );

  // Title styles
  static const TextStyle title1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle title2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
  );

  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.2,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 0.2,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.7,
    letterSpacing: 0.3,
  );

  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.6,
    letterSpacing: 0.2,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.7,
    letterSpacing: 0.3,
  );

  // Caption styles
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.2,
  );

  static const TextStyle captionSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.1,
  );
}

/// Premium spacing system (8px base unit)
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // Common edge insets
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(
    horizontal: xl,
  );

  // Vertical padding
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(
    vertical: sm,
  );
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(
    vertical: md,
  );
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(
    vertical: lg,
  );
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(
    vertical: xl,
  );
}

/// Premium border radius system
class AppRadius {
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double full = 9999;

  // Border radius objects
  static const BorderRadius borderRadiusXs = BorderRadius.all(
    Radius.circular(xs),
  );
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(sm),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(md),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(lg),
  );
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(xl),
  );
  static const BorderRadius borderRadiusXxl = BorderRadius.all(
    Radius.circular(xxl),
  );
}

/// Premium elevation/shadow system
class AppElevation {
  // Subtle shadows
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: -2,
    ),
  ];

  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 8),
      blurRadius: 16,
      spreadRadius: -4,
    ),
  ];

  static const List<BoxShadow> shadowXxl = [
    BoxShadow(
      color: Color(0x25000000),
      offset: Offset(0, 12),
      blurRadius: 32,
      spreadRadius: -8,
    ),
  ];

  // Glass morphism shadow
  static const List<BoxShadow> shadowGlass = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];
}

/// Opacity constants
class AppOpacity {
  static const double disabled = 0.5;
  static const double hover = 0.08;
  static const double focus = 0.12;
  static const double press = 0.16;
  static const double glass = 0.8;
}

/// Animation durations
class AppDuration {
  static const Duration fastest = Duration(milliseconds: 50);
  static const Duration fast = Duration(milliseconds: 100);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration slower = Duration(milliseconds: 500);
  static const Duration slowest = Duration(milliseconds: 800);
}

/// Responsive breakpoints
class AppBreakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double wide = 1440;

  static bool isMobile(double width) => width < tablet;
  static bool isTablet(double width) => width >= tablet && width < desktop;
  static bool isDesktop(double width) => width >= desktop;
}

/// Common gradients
class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      AppColors.gradientStart,
      AppColors.gradientMid,
      AppColors.gradientEnd,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonHeader = LinearGradient(
    colors: [Color(0xFF0D1D4A), Color(0xFF111E63), Color(0xFF1E3AA7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightHeader = LinearGradient(
    colors: [Color(0xFFE8EEFF), Color(0xFFDCE7FF), Color(0xFFF7FAFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [AppColors.success, Color(0xFF229954)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [AppColors.error, Color(0xFFC0392B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [AppColors.warning, Color(0xFFD68910)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Common icon sizes
class AppIconSize {
  static const double xs = 16;
  static const double sm = 20;
  static const double md = 24;
  static const double lg = 32;
  static const double xl = 48;
  static const double xxl = 64;
}
