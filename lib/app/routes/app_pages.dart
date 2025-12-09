import 'package:get/get.dart';

import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/create_profile/create_profile_binding.dart';
import '../modules/create_profile/create_profile_view.dart';
import '../modules/recipe_detail/recipe_detail_binding.dart';
import '../modules/recipe_detail/recipe_detail_view.dart';
import '../modules/create_recipe/create_recipe_binding.dart';
import '../modules/create_recipe/create_recipe_view.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/profile/profile_view.dart';
import '../modules/search/search_binding.dart';
import '../modules/search/search_view.dart';
import '../modules/settings/settings_binding.dart';
import '../modules/settings/settings_view.dart';
import '../modules/notifications/notifications_binding.dart';
import '../modules/notifications/notifications_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => const HomeView(), binding: HomeBinding()),
    GetPage(name: _Paths.SPLASH, page: () => const SplashView(), binding: SplashBinding()),
    GetPage(name: _Paths.LOGIN, page: () => const LoginView(), binding: LoginBinding()),
    GetPage(
      name: _Paths.CREATE_PROFILE,
      page: () => const CreateProfileView(),
      binding: CreateProfileBinding(),
    ),
    GetPage(
      name: _Paths.RECIPE_DETAILS,
      page: () => const RecipeDetailView(),
      binding: RecipeDetailBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_RECIPE,
      page: () => const CreateRecipeView(),
      binding: CreateRecipeBinding(),
    ),
    GetPage(name: _Paths.SEARCH, page: () => const SearchView(), binding: SearchBinding()),
    GetPage(name: _Paths.PROFILE, page: () => const ProfileView(), binding: ProfileBinding()),
    GetPage(name: _Paths.SETTINGS, page: () => const SettingsView(), binding: SettingsBinding()),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
  ];
}
