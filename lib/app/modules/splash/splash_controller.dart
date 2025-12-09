import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_pages.dart';
import '../../core/constants/storage_keys.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onReady() {
    super.onReady();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));

    // Check if user has seen onboarding
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool(StorageKeys.hasSeenOnboarding) ?? false;

    if (!hasSeenOnboarding) {
      // First time user - show onboarding
      Get.offAllNamed(Routes.ONBOARDING);
      return;
    }

    // Check if user is logged in
    if (_authService.isLoggedIn) {
      // User is logged in, check if they have a profile
      if (_authService.hasCompletedProfile) {
        Get.offAllNamed(Routes.HOME);
      } else {
        // Logged in but no profile - redirect to create profile
        Get.offAllNamed(Routes.CREATE_PROFILE);
      }
    } else {
      // Not logged in - show login
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
