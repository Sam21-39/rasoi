import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/enums/app_theme_mode.dart';
import '../core/constants/storage_keys.dart';

/// Controller for managing app theme
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final Rx<AppThemeMode> _themeMode = AppThemeMode.system.obs;
  AppThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  /// Load theme mode from storage
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(StorageKeys.themeMode);

      if (savedMode != null) {
        _themeMode.value = AppThemeModeHelper.fromString(savedMode);
      }
    } catch (e) {
      // Default to system theme if error
      _themeMode.value = AppThemeMode.system;
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode.value = mode;

    // Update GetX theme
    switch (mode) {
      case AppThemeMode.light:
        Get.changeThemeMode(ThemeMode.light);
        break;
      case AppThemeMode.dark:
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case AppThemeMode.system:
        Get.changeThemeMode(ThemeMode.system);
        break;
    }

    // Save to storage
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StorageKeys.themeMode, mode.value);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Toggle between light and dark
  Future<void> toggleTheme() async {
    if (_themeMode.value == AppThemeMode.light) {
      await setThemeMode(AppThemeMode.dark);
    } else {
      await setThemeMode(AppThemeMode.light);
    }
  }

  /// Get current ThemeMode for GetX
  ThemeMode get currentThemeMode {
    switch (_themeMode.value) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Check if dark mode is active
  bool get isDarkMode {
    if (_themeMode.value == AppThemeMode.system) {
      return Get.isDarkMode;
    }
    return _themeMode.value == AppThemeMode.dark;
  }
}
