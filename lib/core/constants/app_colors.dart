import 'package:flutter/material.dart';

/// Rasoi App Color Palette
/// Design system colors as per PRD specification
class AppColors {
  AppColors._();

  // ============================================
  // Primary Colors
  // ============================================

  /// Primary Orange - represents warmth and food
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8F66);
  static const Color primaryDark = Color(0xFFE55A2B);

  /// Secondary Deep Blue - trust and stability
  static const Color secondary = Color(0xFF004E89);
  static const Color secondaryLight = Color(0xFF3371A3);
  static const Color secondaryDark = Color(0xFF003A66);

  // ============================================
  // Background Colors
  // ============================================

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF7F7F7);
  static const Color surfaceVariant = Color(0xFFF0F0F0);
  static const Color card = Color(0xFFFFFFFF);

  // ============================================
  // Text Colors
  // ============================================

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // ============================================
  // Semantic Colors
  // ============================================

  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);

  // ============================================
  // Border & Divider Colors
  // ============================================

  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color disabled = Color(0xFFBDBDBD);

  // ============================================
  // Gradient Colors
  // ============================================

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000)],
  );

  // ============================================
  // Category Colors (for chips and tags)
  // ============================================

  static const Color breakfast = Color(0xFFFFA726);
  static const Color lunch = Color(0xFF66BB6A);
  static const Color dinner = Color(0xFF5C6BC0);
  static const Color snacks = Color(0xFFEC407A);
  static const Color desserts = Color(0xFFAB47BC);
  static const Color beverages = Color(0xFF26C6DA);

  // ============================================
  // Difficulty Colors
  // ============================================

  static const Color easy = Color(0xFF4CAF50);
  static const Color medium = Color(0xFFFF9800);
  static const Color hard = Color(0xFFF44336);

  // ============================================
  // Dietary Type Colors
  // ============================================

  static const Color vegetarian = Color(0xFF4CAF50);
  static const Color nonVegetarian = Color(0xFFF44336);
  static const Color vegan = Color(0xFF8BC34A);
  static const Color eggetarian = Color(0xFFFFEB3B);
}
