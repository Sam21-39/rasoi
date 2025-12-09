import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/enums/app_language.dart';
import '../core/constants/storage_keys.dart';

/// Controller for managing app language
class LanguageController extends GetxController {
  static LanguageController get to => Get.find();

  final Rx<AppLanguage> _language = AppLanguage.english.obs;
  AppLanguage get language => _language.value;

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  /// Load language from storage
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLang = prefs.getString(StorageKeys.language);

      if (savedLang != null) {
        _language.value = AppLanguageHelper.fromCode(savedLang);
        await _updateLocale();
      }
    } catch (e) {
      // Default to English if error
      _language.value = AppLanguage.english;
    }
  }

  /// Set language
  Future<void> setLanguage(AppLanguage lang) async {
    _language.value = lang;
    await _updateLocale();

    // Save to storage
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StorageKeys.language, lang.code);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Update GetX locale
  Future<void> _updateLocale() async {
    final locale = Locale(_language.value.code, _language.value.countryCode);
    await Get.updateLocale(locale);
  }

  /// Get current locale
  Locale get currentLocale {
    return Locale(_language.value.code, _language.value.countryCode);
  }
}
