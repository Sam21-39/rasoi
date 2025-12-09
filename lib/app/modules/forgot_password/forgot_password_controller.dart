import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../core/utils/validators.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool emailSent = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> sendResetEmail() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final result = await _authService.sendPasswordResetEmail(emailController.text.trim());

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
      (_) {
        emailSent.value = true;
        Get.snackbar(
          'success'.tr,
          'Password reset email sent. Please check your inbox.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      },
    );
  }

  void navigateBack() {
    Get.back();
  }
}
