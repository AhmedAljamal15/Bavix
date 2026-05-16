import 'dart:ui';
import 'package:flutter/material.dart';

/// Gradient hero header used across HR creation forms.
class HrFormHeroHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Gradient? gradient;

  const HrFormHeroHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Default gradient if none provided
    final defaultGradient = LinearGradient(
      colors: isDark
          ? [const Color(0xFF020617), primaryColor.withValues(alpha: .5), const Color(0xFF101A35)]
          : [primaryColor.withValues(alpha: .15), Colors.white],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 44, 18, 30),
      decoration: BoxDecoration(
        gradient: gradient ?? defaultGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 74,
            width: 74,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: primaryColor.withValues(alpha: .14),
            ),
            child: Icon(icon, color: primaryColor, size: 36),
          ),
          const SizedBox(height: 14),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Glassmorphic section card used to group form fields.
class HrFormSectionCard extends StatelessWidget {
  final List<Widget> children;

  const HrFormSectionCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final borderColor = Theme.of(context).dividerColor.withValues(alpha: .35);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor.withValues(alpha: isDark ? .92 : .98),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? .18 : .06),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}

/// Label for form fields.
class HrFormLabel extends StatelessWidget {
  final String text;

  const HrFormLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Standardized Input Decoration for HR forms.
InputDecoration hrFormInputDecoration(BuildContext context, String hint, {IconData? prefixIcon}) {
  final fieldColor = Theme.of(context).inputDecorationTheme.fillColor ??
      Theme.of(context).colorScheme.surfaceContainerHighest;
  final borderColor = Theme.of(context).dividerColor.withValues(alpha: .35);
  final primaryColor = Theme.of(context).colorScheme.primary;
  final subText = Theme.of(context).colorScheme.onSurfaceVariant;

  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: subText),
    filled: true,
    fillColor: fieldColor,
    prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: subText) : null,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: primaryColor, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
    ),
  );
}

/// Tappable date tile used in forms.
class HrFormDateTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  final Color? primaryColor;

  const HrFormDateTile({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? Theme.of(context).colorScheme.primary;
    final fieldColor = Theme.of(context).inputDecorationTheme.fillColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;
    final borderColor = Theme.of(context).dividerColor.withValues(alpha: .35);
    final text = Theme.of(context).colorScheme.onSurface;
    final subText = Theme.of(context).colorScheme.onSurfaceVariant;
    final selected = !value.toLowerCase().contains('select');

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: fieldColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                color: primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: subText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: selected ? text : subText,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: subText),
          ],
        ),
      ),
    );
  }
}

/// Standardized fixed bottom submit button.
class HrFormSubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback? onPressed;
  final String label;

  const HrFormSubmitButton({
    super.key,
    required this.isSubmitting,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final border = Theme.of(context).dividerColor.withValues(alpha: .35);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: .96),
        border: Border(top: BorderSide(color: border)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              disabledBackgroundColor: primary.withValues(alpha: .45),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: isSubmitting
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
          ),
        ),
      ),
    );
  }
}
