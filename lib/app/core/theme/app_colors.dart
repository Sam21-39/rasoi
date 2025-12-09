import 'package:flutter/material.dart';

/// Light theme colors
class AppColors {
  static const primary = Color(0xFFE85D04); // Deep Orange
  static const secondary = Color(0xFF2D6A4F); // Hunter Green
  static const background = Color(0xFFFAFAFA); // Off-white
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF212529);
  static const textSecondary = Color(0xFF6C757D);
  static const error = Color(0xFFDC3545);
  static const success = Color(0xFF28A745);
  static const warning = Color(0xFFFFC107);
  static const info = Color(0xFF17A2B8);

  AppColors._();
}

/// Dark theme colors
class AppColorsDark {
  static const primary = Color(0xFFFF8C42); // Lighter orange for dark mode
  static const secondary = Color(0xFF52B788); // Lighter green for dark mode
  static const background = Color(0xFF121212); // Dark background
  static const surface = Color(0xFF1E1E1E); // Elevated surface
  static const surfaceVariant = Color(0xFF2C2C2C); // Card background
  static const textPrimary = Color(0xFFE0E0E0); // Light text
  static const textSecondary = Color(0xFFB0B0B0); // Muted text
  static const error = Color(0xFFEF5350);
  static const success = Color(0xFF66BB6A);
  static const warning = Color(0xFFFFCA28);
  static const info = Color(0xFF29B6F6);
  static const divider = Color(0xFF3A3A3A);

  AppColorsDark._();
}
