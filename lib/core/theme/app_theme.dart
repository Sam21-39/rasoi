import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Rasoi App Theme Configuration
/// Material 3 theme with custom colors and typography
class AppTheme {
  AppTheme._();

  // ============================================
  // Light Theme
  // ============================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnSecondary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.background,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        titleTextStyle: _headingTextStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: _bodyTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(64, 48),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: _bodyTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: _bodyTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: _bodyTextStyle.copyWith(color: AppColors.textSecondary),
        hintStyle: _bodyTextStyle.copyWith(color: AppColors.textHint),
        errorStyle: _bodyTextStyle.copyWith(color: AppColors.error, fontSize: 12),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary.withOpacity(0.2),
        disabledColor: AppColors.disabled.withOpacity(0.3),
        labelStyle: _bodyTextStyle.copyWith(fontSize: 14),
        secondaryLabelStyle: _bodyTextStyle.copyWith(fontSize: 14, color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.background,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.background,
        elevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: _headingTextStyle.copyWith(fontSize: 20),
        contentTextStyle: _bodyTextStyle,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: _bodyTextStyle.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1, space: 1),

      // Icon Theme
      iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 24),

      // Text Theme
      textTheme: _textTheme,
    );
  }

  // ============================================
  // Text Styles
  // ============================================

  static TextStyle get _headingTextStyle => GoogleFonts.poppins(color: AppColors.textPrimary);

  static TextStyle get _bodyTextStyle => GoogleFonts.roboto(color: AppColors.textPrimary);

  static TextTheme get _textTheme => TextTheme(
    // Display
    displayLarge: _headingTextStyle.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: _headingTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold),
    displaySmall: _headingTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),

    // Headlines (Poppins)
    headlineLarge: _headingTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
    headlineMedium: _headingTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
    headlineSmall: _headingTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w500),

    // Titles
    titleLarge: _headingTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: _headingTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
    titleSmall: _headingTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),

    // Body (Roboto)
    bodyLarge: _bodyTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: _bodyTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal),
    bodySmall: _bodyTextStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
    ),

    // Labels
    labelLarge: _bodyTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: _bodyTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: _bodyTextStyle.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
    ),
  );
}
