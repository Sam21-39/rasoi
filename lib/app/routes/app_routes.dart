/// App Routes
/// Defines all route names in the app
abstract class AppRoutes {
  // Auth Module
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String dietaryPreference = '/dietary-preference';

  // Main Module
  static const String main = '/main';
  static const String home = '/home';
  static const String search = '/search';
  static const String createRecipe = '/create-recipe';
  static const String saved = '/saved';
  static const String profile = '/profile';

  // Recipe Module
  static const String recipeDetail = '/recipe/:id';
  static const String editRecipe = '/edit-recipe/:id';

  // Profile Module
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String userProfile = '/user/:id';

  // Utility
  static const String notFound = '/404';

  /// Generate recipe detail route with ID
  static String recipeDetailPath(String recipeId) => '/recipe/$recipeId';

  /// Generate edit recipe route with ID
  static String editRecipePath(String recipeId) => '/edit-recipe/$recipeId';

  /// Generate user profile route with ID
  static String userProfilePath(String userId) => '/user/$userId';
}
