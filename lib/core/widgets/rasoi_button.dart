import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Rasoi Button Widget
/// A customizable button with primary, secondary, and text variants
class RasoiButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final RasoiButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final double height;

  const RasoiButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = RasoiButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.width,
    this.height = 48,
  });

  /// Primary filled button
  const RasoiButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.width,
    this.height = 48,
  }) : type = RasoiButtonType.primary;

  /// Secondary outlined button
  const RasoiButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.width,
    this.height = 48,
  }) : type = RasoiButtonType.secondary;

  /// Text-only button
  const RasoiButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.width,
    this.height = 48,
  }) : type = RasoiButtonType.text;

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == RasoiButtonType.primary ? Colors.white : AppColors.primary,
              ),
            ),
          )
        : _buildButtonContent();

    Widget button;

    switch (type) {
      case RasoiButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(width ?? (isFullWidth ? double.infinity : 64), height),
          ),
          child: buttonChild,
        );
        break;
      case RasoiButtonType.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(width ?? (isFullWidth ? double.infinity : 64), height),
          ),
          child: buttonChild,
        );
        break;
      case RasoiButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(minimumSize: Size(width ?? 64, height)),
          child: buttonChild,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(text)],
      );
    }
    return Text(text);
  }
}

enum RasoiButtonType { primary, secondary, text }
