import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Welcome View
/// Sign-in screen with Google authentication
class WelcomeView extends GetView<AuthController> {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Hero Section
              _buildHeroSection(),

              const Spacer(),

              // Sign In Section
              _buildSignInSection(),

              const SizedBox(height: 24),

              // Terms and Privacy
              _buildTermsText(context),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        // App Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(child: Text('🍳', style: TextStyle(fontSize: 50))),
        ),
        const SizedBox(height: 32),

        // App Name
        const Text(
          'Rasoi',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),

        // Tagline
        const Text(
          AppStrings.welcomeSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 48),

        // Feature Highlights
        _buildFeatureHighlights(),
      ],
    );
  }

  Widget _buildFeatureHighlights() {
    return Column(
      children: [
        _buildFeatureItem(
          icon: Icons.restaurant_menu,
          title: 'Discover Recipes',
          subtitle: 'Find authentic Indian dishes',
        ),
        const SizedBox(height: 16),
        _buildFeatureItem(
          icon: Icons.people,
          title: 'Join Community',
          subtitle: 'Share your culinary creations',
        ),
        const SizedBox(height: 16),
        _buildFeatureItem(
          icon: Icons.bookmark,
          title: 'Save Favorites',
          subtitle: 'Build your recipe collection',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(subtitle, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignInSection() {
    return Column(
      children: [
        // Google Sign In Button
        Obx(() => _buildGoogleButton()),

        const SizedBox(height: 16),

        // Error Message
        Obx(() {
          if (controller.errorMessage.value.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: AppColors.error, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildGoogleButton() {
    final isLoading = controller.isLoading.value;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: isLoading ? null : _handleGoogleSignIn,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Logo
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    AppStrings.signInWithGoogle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    controller.clearError();
    final success = await controller.signInWithGoogle();

    if (success) {
      if (controller.isNewUser.value || controller.currentUser.value.dietaryPreferences.isEmpty) {
        Get.offAllNamed(AppRoutes.dietaryPreference);
      } else {
        Get.offAllNamed(AppRoutes.main);
      }
    }
  }

  Widget _buildTermsText(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'By continuing, you agree to our ',
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
