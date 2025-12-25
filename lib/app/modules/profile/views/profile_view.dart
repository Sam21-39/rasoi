import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/profile_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Profile View
class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          final user = authController.currentUser.value;

          return CustomScrollView(
            slivers: [
              // Profile Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Settings button
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.settings_outlined),
                          onPressed: () => Get.toNamed(AppRoutes.settings),
                        ),
                      ),

                      // Profile Picture
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.surface,
                        backgroundImage: user.photoUrl.isNotEmpty
                            ? CachedNetworkImageProvider(user.photoUrl)
                            : null,
                        child: user.photoUrl.isEmpty ? const Icon(Icons.person, size: 50) : null,
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Text(
                        user.displayName.isEmpty ? 'User' : user.displayName,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      if (user.bio.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          user.bio,
                          style: const TextStyle(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStat(count: user.recipesCount, label: AppStrings.recipesCount),
                          const SizedBox(width: 32),
                          _buildStat(count: user.likesReceived, label: AppStrings.likesCount),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Edit Profile Button
                      OutlinedButton(
                        onPressed: () => Get.toNamed(AppRoutes.editProfile),
                        child: const Text(AppStrings.editProfile),
                      ),
                    ],
                  ),
                ),
              ),

              // Tabs
              SliverToBoxAdapter(
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: _TabButton(
                          label: AppStrings.myRecipes,
                          isSelected: controller.selectedTab.value == 0,
                          onTap: () => controller.changeTab(0),
                        ),
                      ),
                      Expanded(
                        child: _TabButton(
                          label: AppStrings.savedRecipes,
                          isSelected: controller.selectedTab.value == 1,
                          onTap: () => controller.changeTab(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverFillRemaining(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final recipes = controller.selectedTab.value == 0
                      ? controller.myRecipes
                      : controller.savedRecipes;

                  if (recipes.isEmpty) {
                    return _buildEmptyState(controller.selectedTab.value == 0);
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: Text('Recipe')),
                      );
                    },
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStat({required int count, required String label}) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildEmptyState(bool isMyRecipes) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isMyRecipes ? '🍳' : '📚', style: const TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(
            isMyRecipes ? AppStrings.noMyRecipes : AppStrings.noSavedRecipes,
            style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
