/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Rasoi';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Share Your Culinary Journey';

  // Pagination
  static const int paginationLimit = 10;
  static const int maxRecipesPerPage = 20;

  // File Upload
  static const int maxImageSizeMB = 5;
  static const int maxImageSizeBytes = maxImageSizeMB * 1024 * 1024;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];

  // Text Limits
  static const int maxBioLength = 500;
  static const int maxRecipeTitleLength = 100;
  static const int maxIngredientLength = 200;
  static const int maxInstructionLength = 500;
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minDisplayNameLength = 2;
  static const int maxDisplayNameLength = 50;

  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 24);

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Debounce
  static const Duration searchDebounce = Duration(milliseconds: 500);

  // Private constructor to prevent instantiation
  AppConstants._();
}
