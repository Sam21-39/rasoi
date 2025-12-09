import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_pages.dart';

class SignupController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final displayNameController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool agreedToTerms = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    displayNameController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void toggleTermsAgreement(bool? value) {
    agreedToTerms.value = value ?? false;
  }

  Future<void> signup() async {
    if (!formKey.currentState!.validate()) return;

    if (!agreedToTerms.value) {
      Get.snackbar(
        'error'.tr,
        'Please agree to the terms and conditions',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    final result = await _authService.signUpWithEmail(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      displayName: displayNameController.text.trim(),
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
        Get.snackbar(
          'success'.tr,
          'verification_email_sent'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Navigate to home (or email verification screen)
        Get.offAllNamed(Routes.HOME);
      },
    );
  }

  void navigateToLogin() {
    Get.offNamed(Routes.LOGIN);
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '${'confirm_password'.tr} ${'email_required'.tr}';
    }
    if (value != passwordController.text) {
      return 'passwords_dont_match'.tr;
    }
    return null;
  }
}
