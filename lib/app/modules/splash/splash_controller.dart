import 'package:get/get.dart';
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

    // Check if user is logged in using AuthService
    // We can access it via Get.find since it is permanent
    try {
      final authService = Get.find<AuthService>();
      if (authService.isLoggedIn) {
        // Here we could check if profile is complete
        // For now, go to Home
        Get.offNamed(Routes.HOME);
      } else {
        Get.offNamed(Routes.LOGIN);
      }
    } catch (e) {
      // Fallback
      Get.offNamed(Routes.LOGIN);
    }
  }
}
