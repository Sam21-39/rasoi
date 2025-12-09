import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_pages.dart';

class CreateProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final bioController = TextEditingController();

  final RxBool isLoading = false.obs;

  void saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final currentUser = _authService.currentUser.value;
      if (currentUser == null) return;

      final newUser = UserModel(
        uid: currentUser.uid,
        displayName: nameController.text.trim(),
        phoneNumber: currentUser.phoneNumber,
        photoURL: currentUser.photoURL ?? '', // Could add image picker here too
        bio: bioController.text.trim(),
        followerCount: 0,
        followingCount: 0,
        recipeCount: 0,
      );

      await _authService.createUserProfile(newUser);
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar("Error", "Failed to save_profile: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
