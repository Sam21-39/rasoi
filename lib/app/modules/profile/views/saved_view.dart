import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Saved View (for bottom nav)
class SavedView extends GetView<ProfileController> {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.savedRecipes),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.savedRecipes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('📚', style: TextStyle(fontSize: 60)),
                const SizedBox(height: 16),
                const Text(
                  AppStrings.noSavedRecipes,
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                const Text(
                  AppStrings.startSavingRecipes,
                  style: TextStyle(color: AppColors.textHint),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: controller.savedRecipes.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('Saved Recipe')),
            );
          },
        );
      }),
    );
  }
}
