import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Rasoi Card Widget
/// A styled card with consistent elevation and styling
class RasoiCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double elevation;
  final double borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Border? border;

  const RasoiCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.elevation = 2,
    this.borderRadius = 12,
    this.backgroundColor,
    this.onTap,
    this.onLongPress,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.card,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );

    if (onTap != null || onLongPress != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(borderRadius),
          child: card,
        ),
      );
    }

    return card;
  }
}
