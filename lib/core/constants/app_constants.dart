/// Rasoi App Constants
/// Configuration values and app-wide constants
class AppConstants {
  AppConstants._();

  // ============================================
  // App Info
  // ============================================

  static const String appName = 'Rasoi';
  static const String appNameHindi = 'रसोई';
  static const String appTagline = 'Your pocket kitchen companion';
  static const String appVersion = '1.0.0';

  // ============================================
  // Pagination
  // ============================================

  static const int recipesPerPage = 20;
  static const int commentsPerPage = 20;
  static const int maxCachedRecipes = 50;

  // ============================================
  // Validation
  // ============================================

  static const int maxRecipeTitleLength = 100;
  static const int maxRecipeDescriptionLength = 200;
  static const int maxCommentLength = 500;
  static const int maxBioLength = 200;
  static const int maxDisplayNameLength = 50;
  static const int minIngredientsCount = 2;
  static const int minStepsCount = 3;

  /// Alias for ingredientUnits for convenience
  static const List<String> units = ingredientUnits;

  // ============================================
  // File Sizes
  // ============================================

  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const int compressedImageQuality = 70;
  static const int thumbnailWidth = 200;
  static const int thumbnailHeight = 200;
  static const int fullImageWidth = 1024;
  static const int fullImageHeight = 1024;

  // ============================================
  // Timeouts & Debounce
  // ============================================

  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const Duration sessionTimeout = Duration(days: 30);
  static const Duration syncInterval = Duration(minutes: 5);
  static const Duration cacheExpiry = Duration(days: 7);
  static const Duration editCommentWindow = Duration(minutes: 5);

  // ============================================
  // UI Constants
  // ============================================

  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;
  static const double borderRadiusCircle = 50.0;

  static const double elevationCard = 2.0;
  static const double elevationButton = 4.0;
  static const double elevationAppBar = 4.0;
  static const double elevationBottomNav = 8.0;
  static const double elevationModal = 16.0;

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  static const double minTapTarget = 48.0;

  // ============================================
  // Categories
  // ============================================

  static const List<String> categories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Desserts',
    'North Indian',
    'South Indian',
    'Chinese',
    'Fast Food',
    'Beverages',
  ];

  static const Map<String, String> categoriesHindi = {
    'Breakfast': 'नाश्ता',
    'Lunch': 'दोपहर का खाना',
    'Dinner': 'रात का खाना',
    'Snacks': 'स्नैक्स',
    'Desserts': 'मिठाई',
    'North Indian': 'उत्तर भारतीय',
    'South Indian': 'दक्षिण भारतीय',
    'Chinese': 'चाइनीज',
    'Fast Food': 'फास्ट फूड',
    'Beverages': 'पेय पदार्थ',
  };

  // ============================================
  // Dietary Types
  // ============================================

  static const List<String> dietaryTypes = ['Vegetarian', 'Non-Vegetarian', 'Vegan', 'Eggetarian'];

  // ============================================
  // Difficulty Levels
  // ============================================

  static const List<String> difficultyLevels = ['Easy', 'Medium', 'Hard'];

  // ============================================
  // Cooking Time Filters
  // ============================================

  static const Map<String, int> cookingTimeFilters = {
    '< 15 min': 15,
    '15-30 min': 30,
    '30-60 min': 60,
    '> 60 min': 999,
  };

  // ============================================
  // Serving Size Options
  // ============================================

  static const List<String> servingSizes = ['1-2', '3-4', '5+'];

  // ============================================
  // Ingredient Units
  // ============================================

  static const List<String> ingredientUnits = [
    'cup',
    'tbsp',
    'tsp',
    'grams',
    'kg',
    'ml',
    'liters',
    'pieces',
    'bunch',
    'pinch',
    'to taste',
    'as needed',
  ];
}
