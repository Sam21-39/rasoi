/// Supported app languages
enum AppLanguage { english, hindi }

extension AppLanguageExtension on AppLanguage {
  String get displayName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.hindi:
        return 'हिन्दी';
    }
  }

  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.hindi:
        return 'hi';
    }
  }

  String get countryCode {
    switch (this) {
      case AppLanguage.english:
        return 'US';
      case AppLanguage.hindi:
        return 'IN';
    }
  }
}

/// Helper class for AppLanguage
class AppLanguageHelper {
  static AppLanguage fromCode(String code) {
    switch (code.toLowerCase()) {
      case 'en':
        return AppLanguage.english;
      case 'hi':
        return AppLanguage.hindi;
      default:
        return AppLanguage.english;
    }
  }
}
