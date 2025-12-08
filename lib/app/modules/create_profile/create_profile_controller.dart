import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user_model.dart';
import '../../routes/app_pages.dart';

class CreateProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final nameController = TextEditingController();
  final bioController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Pre-fill if we have data (e.g. from previous session)
    if (_authService.appUser.value != null) {
      nameController.text = _authService.appUser.value!.displayName ?? '';
      bioController.text = _authService.appUser.value!.bio ?? '';
    }
  }

  void saveProfile() async {
    if (nameController.text.isEmpty) {
      Get.snackbar("Error", "Name is required");
      return;
    }

    isLoading.value = true;
    try {
      final user = UserModel(
        uid: _authService.currentUser.value!.uid,
        phoneNumber: _authService.currentUser.value!.phoneNumber,
        displayName: nameController.text.trim(),
        bio: bioController.text.trim(),
        createdAt: DateTime.now(),
        // Initialize counts
        followerCount: 0,
        followingCount: 0,
        recipeCount: 0,
      );

      await _authService.createUserProfile(user);
      isLoading.value = false;
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Failed to save profile: $e");
    }
  }
}
