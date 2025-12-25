import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/constants/app_colors.dart';

/// Splash View
/// Initial loading screen with animation
class SplashView extends GetView<AuthController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate after splash delay
    _navigateAfterDelay();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(child: Text('🍳', style: TextStyle(fontSize: 60))),
            ),
            const SizedBox(height: 24),

            // App Name
            const Text(
              'Rasoi',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),

            // Hindi name
            const Text('रसोई', style: TextStyle(fontSize: 24, color: Colors.white70)),
            const SizedBox(height: 8),

            // Tagline
            const Text(
              'Your pocket kitchen companion',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 48),

            // Loading indicator
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is logged in
    if (controller.isLoggedIn) {
      if (controller.isNewUser.value || controller.currentUser.value.dietaryPreferences.isEmpty) {
        Get.offAllNamed(AppRoutes.dietaryPreference);
      } else {
        Get.offAllNamed(AppRoutes.main);
      }
    } else {
      Get.offAllNamed(AppRoutes.welcome);
    }
  }
}
