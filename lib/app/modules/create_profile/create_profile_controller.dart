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

  @override
  void onClose() {
    nameController.dispose();
    bioController.dispose();
    super.onClose();
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final currentUser = _authService.currentUser.value;
      if (currentUser == null) return;

      final newUser = UserModel(
        uid: currentUser.uid,
        email: currentUser.email,
        displayName: nameController.text.trim(),
        photoURL: currentUser.photoURL ?? '',
        bio: bioController.text.trim(),
        isEmailVerified: currentUser.emailVerified,
        followerCount: 0,
        followingCount: 0,
        recipeCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        preferences: {'themeMode': 'system', 'language': 'en', 'notificationsEnabled': true},
      );

      await _authService.updateUserProfile(newUser);
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar("Error", "Failed to save profile: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
