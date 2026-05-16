import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';

/// Premium animations for enterprise app
class PremiumAnimations {
  /// Fade + Slide entrance animation
  static List<Effect<dynamic>> fadeSlideInEffect() => [
    const FadeEffect(duration: AppDuration.normal),
    const SlideEffect(
      duration: AppDuration.normal,
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ),
  ];

  /// Stagger effect for list items
  static List<Effect<dynamic>> staggerEffect({
    int itemCount = 5,
    Duration delay = const Duration(milliseconds: 50),
  }) {
    return [
      const FadeEffect(duration: AppDuration.slow),
      const SlideEffect(
        duration: AppDuration.slow,
        begin: Offset(0, 0.2),
        end: Offset.zero,
      ),
    ];
  }

  /// Scale + Fade entry
  static List<Effect<dynamic>> scaleInEffect() => [
    const ScaleEffect(
      duration: AppDuration.normal,
      begin: Offset(0.8, 0.8),
      end: Offset.zero,
    ),
    const FadeEffect(duration: AppDuration.normal),
  ];

  /// Bounce entrance
  static List<Effect<dynamic>> bounceInEffect() => [
    const ScaleEffect(
      duration: AppDuration.slow,
      begin: Offset(0.5, 0.5),
      end: Offset.zero,
      curve: Curves.elasticOut,
    ),
    const FadeEffect(duration: AppDuration.slow),
  ];

  /// Rotate + Fade effect
  static List<Effect<dynamic>> rotateInEffect() => [
    RotateEffect(duration: AppDuration.slow, begin: -0.5, end: 0),
    const FadeEffect(duration: AppDuration.slow),
  ];
}

/// Animated page transition route
class PageTransitionRoute extends PageRouteBuilder {
  final Widget child;
  final PageTransitionType transitionType;

  PageTransitionRoute({
    required this.child,
    this.transitionType = PageTransitionType.fadeSlide,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return _buildTransition(
             child,
             animation,
             secondaryAnimation,
             transitionType,
           );
         },
         transitionDuration: AppDuration.normal,
       );

  static Widget _buildTransition(
    Widget child,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    PageTransitionType transitionType,
  ) {
    switch (transitionType) {
      case PageTransitionType.fadeSlide:
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );

      case PageTransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );

      case PageTransitionType.rotate:
        return RotationTransition(
          turns: Tween<double>(begin: 0, end: 1).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );

      case PageTransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case PageTransitionType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case PageTransitionType.fade:
      default:
        return FadeTransition(opacity: animation, child: child);
    }
  }
}

/// Page transition types
enum PageTransitionType {
  fade,
  fadeSlide,
  scale,
  rotate,
  slideLeft,
  slideRight,
}

/// Animated counter widget for KPI metrics
class AnimatedCounter extends StatefulWidget {
  final int endValue;
  final Duration duration;
  final TextStyle textStyle;

  const AnimatedCounter({
    super.key,
    required this.endValue,
    this.duration = AppDuration.slower,
    required this.textStyle,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = IntTween(begin: 0, end: widget.endValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(_animation.value.toString(), style: widget.textStyle);
      },
    );
  }
}

/// Animated list item entrance
class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration staggerDuration;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.staggerDuration = const Duration(milliseconds: 50),
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: AppDuration.slow, vsync: this);

    // Stagger animations based on index
    Future.delayed(widget.staggerDuration * widget.index, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
            ),
        child: widget.child,
      ),
    );
  }
}

/// Smooth color transition
class AnimatedColorWidget extends StatefulWidget {
  final Color startColor;
  final Color endColor;
  final Duration duration;
  final Widget Function(Color) builder;

  const AnimatedColorWidget({
    super.key,
    required this.startColor,
    required this.endColor,
    required this.duration,
    required this.builder,
  });

  @override
  State<AnimatedColorWidget> createState() => _AnimatedColorWidgetState();
}

class _AnimatedColorWidgetState extends State<AnimatedColorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _colorAnimation = ColorTween(begin: widget.startColor, end: widget.endColor)
        .animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return widget.builder(_colorAnimation.value ?? widget.startColor);
      },
    );
  }
}

/// Pulse animation effect
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 1.0,
        end: 1.05,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: widget.child,
    );
  }
}
