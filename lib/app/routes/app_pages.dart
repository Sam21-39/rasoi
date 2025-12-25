import 'package:get/get.dart';
import 'app_routes.dart';

// Auth Module Imports
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/splash_view.dart';
import '../modules/auth/views/welcome_view.dart';
import '../modules/auth/views/dietary_preference_view.dart';

// Main Module Imports
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/main_view.dart';

// Recipe Module Imports
import '../modules/recipe_detail/bindings/recipe_detail_binding.dart';
import '../modules/recipe_detail/views/recipe_detail_view.dart';

// Create Recipe Module Imports
import '../modules/create_recipe/bindings/create_recipe_binding.dart';
import '../modules/create_recipe/views/create_recipe_view.dart';

// Search Module Imports
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';

// Profile Module Imports
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/settings_view.dart';

/// App Pages
/// Defines all pages and their bindings for GetX navigation
class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = <GetPage>[
    // ============================================
    // Auth Module
    // ============================================
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: AuthBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.dietaryPreference,
      page: () => const DietaryPreferenceView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),

    // ============================================
    // Main Module (Home with Bottom Nav)
    // ============================================
    GetPage(
      name: AppRoutes.main,
      page: () => const MainView(),
      binding: HomeBinding(),
      transition: Transition.fade,
    ),

    // ============================================
    // Search Module
    // ============================================
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
      transition: Transition.rightToLeft,
    ),

    // ============================================
    // Recipe Module
    // ============================================
    GetPage(
      name: AppRoutes.recipeDetail,
      page: () => const RecipeDetailView(),
      binding: RecipeDetailBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.createRecipe,
      page: () => const CreateRecipeView(),
      binding: CreateRecipeBinding(),
      transition: Transition.downToUp,
      fullscreenDialog: true,
    ),
    GetPage(
      name: AppRoutes.editRecipe,
      page: () => const CreateRecipeView(),
      binding: CreateRecipeBinding(),
      transition: Transition.rightToLeft,
    ),

    // ============================================
    // Profile Module
    // ============================================
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.userProfile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
