import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isCodeSent = false.obs;
  final RxString verificationId = ''.obs;

  // For phone number validation
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  void sendOtp() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;
    String phone = phoneController.text.trim();
    if (!phone.startsWith('+91')) {
      // Allow user to simple type 10 digits, we append +91 for India as per PRD
      phone = '+91$phone';
    }

    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: phone,
        onCodeSent: (String verId, int? resendToken) {
          verificationId.value = verId;
          isCodeSent.value = true;
          isLoading.value = false;
        },
        onVerificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          Get.snackbar("Error", e.message ?? "Verification failed");
        },
        onVerificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolution (Android)
          await _signInWithCredential(credential);
        },
        onCodeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId;
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Failed to send OTP: $e");
    }
  }

  void verifyOtp() async {
    if (otpController.text.length < 6) {
      Get.snackbar("Error", "Please enter valid 6-digit OTP");
      return;
    }

    isLoading.value = true;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otpController.text.trim(),
      );
      await _signInWithCredential(credential);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Invalid OTP: $e");
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      await _authService.signInWithCredential(credential);
      // Check if user has profile, if not go to Create Profile
      // For now, let's just go to CreateProfile if user is new (rudimentary check or always for MVP first time?)
      // We will rely on Splash to direct returning users correctly.
      // But for Login flow:

      // We should check if appUser is set.
      // Wait a bit for auth service to key logic?

      Get.offAllNamed(Routes.HOME);
      // Ideally:
      // if (_authService.appUser.value == null) Get.offAllNamed(Routes.CREATE_PROFILE);
      // else Get.offAllNamed(Routes.HOME);
      // But async timing is tricky. Let's send to Home, and Home redirects.
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Sign in failed: $e");
    }
  }
}
