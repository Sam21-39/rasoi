import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_pages.dart';
import '../../core/utils/validators.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final result = await _authService.signInWithEmail(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    isLoading.value = false;

    result.fold(
      (failure) {
        Get.snackbar(
          'error'.tr,
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      (userCredential) {
        // Check if user has completed profile
        if (_authService.hasCompletedProfile) {
          Get.offAllNamed(Routes.HOME);
        } else {
          // Wait a bit for profile to load
          Future.delayed(const Duration(milliseconds: 500), () {
            if (_authService.hasCompletedProfile) {
              Get.offAllNamed(Routes.HOME);
            } else {
              Get.offAllNamed(Routes.CREATE_PROFILE);
            }
          });
        }
      },
    );
  }

  void navigateToSignup() {
    Get.toNamed(Routes.SIGNUP);
  }

  void navigateToForgotPassword() {
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }
}
