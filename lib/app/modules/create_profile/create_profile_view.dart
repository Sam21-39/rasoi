import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_profile_controller.dart';
import '../../core/theme/app_theme.dart';

class CreateProfileView extends GetView<CreateProfileController> {
  const CreateProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setup Profile")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
              // TODO: Implement Image Picker
            ),
            const SizedBox(height: 16),
            const Text("Add a photo (Optional)", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: "Display Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.bioController,
              decoration: const InputDecoration(
                labelText: "Bio (Max 100 chars)",
                border: OutlineInputBorder(),
              ),
              maxLength: 100,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Complete Setup"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
