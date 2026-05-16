import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:erp_sales/core/helpers/app_navigator.dart';

class AppToast {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void success(String message) {
    _show(
      message: message,
      color: const Color(0xFF45D4CF),
      icon: Icons.info_outline_rounded,
    );
  }

  static void error(String message) {
    _show(
      message: _cleanErrorMessage(message),
      color: const Color(0xFFE74C3C),
      icon: Icons.error_outline_rounded,
    );
  }

  static void info(String message) {
    _show(
      message: message,
      color: const Color(0xFF45D4CF),
      icon: Icons.info_outline_rounded,
    );
  }

  static void _show({
    required String message,
    required Color color,
    required IconData icon,
  }) {
    final context = AppNavigator.navigatorKey.currentContext;
    final overlay = AppNavigator.navigatorKey.currentState?.overlay;

    if (context == null || overlay == null) return;

    _timer?.cancel();
    _entry?.remove();

    _entry = OverlayEntry(
      builder: (_) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 12,
          left: 12,
          right: 12,
          child: _ToastCard(
            message: message,
            color: color,
            icon: icon,
            onClose: _hide,
          ),
        );
      },
    );

    overlay.insert(_entry!);
    _timer = Timer(const Duration(seconds: 3), _hide);
  }

  static void _hide() {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry = null;
  }

  static String _cleanErrorMessage(String error) {
    final lower = error.toLowerCase();

    if (lower.contains('401') || lower.contains('invalid_grant')) {
      return 'Invalid email or password';
    }
    if (lower.contains('403')) return 'Access denied';
    if (lower.contains('404')) return 'Data not found';
    if (lower.contains('500')) return 'Server error, try again later';

    if (lower.contains('no internet') ||
        lower.contains('socketexception') ||
        lower.contains('failed host lookup')) {
      return 'No internet connection';
    }

    if (lower.contains('dioexception') || lower.contains('bad response')) {
      return 'An unexpected error occurred. Please try again.';
    }

    return error.replaceFirst(RegExp(r'^Exception:\s*'), '');
  }
}

class _ToastCard extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback onClose;

  const _ToastCard({
    required this.message,
    required this.color,
    required this.icon,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: .95),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .18),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white.withValues(alpha: .95), size: 19),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onClose,
                    child: const Text(
                      'Open',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
