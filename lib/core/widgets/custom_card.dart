import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

/// Tarjeta personalizada reutilizable
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool hasShadow;
  final Border? border;
  final Gradient? gradient;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.hasShadow = true,
    this.border,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? AppColors.white) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.radiusLg),
        border: border,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppColors.grey300.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppConstants.spacingMd),
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.radiusLg),
          child: card,
        ),
      );
    }

    return card;
  }
}
