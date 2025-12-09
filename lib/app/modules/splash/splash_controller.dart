import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_pages.dart';
import '../../data/services/auth_service.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _checkAuth();
  }

  void _checkAuth() async {
    // Wait for a moment to show splash
    await Future.delayed(const Duration(seconds: 2));

    try {
      final authService = Get.find<AuthService>();
      if (authService.isLoggedIn) {
        Get.offNamed(Routes.HOME);
      } else {
        // Check if onboarding seen
        final prefs = await SharedPreferences.getInstance();
        final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

        if (hasSeenOnboarding) {
          Get.offNamed(Routes.LOGIN);
        } else {
          Get.offNamed(Routes.ONBOARDING);
        }
      }
    } catch (e) {
      Get.offNamed(Routes.LOGIN);
    }
  }
}
