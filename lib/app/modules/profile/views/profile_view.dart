import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/profile_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/recipe_card.dart';
import '../../../../core/widgets/rasoi_button.dart';

/// Profile View
/// Displays user profile with my recipes and saved recipes tabs
class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(),
          _buildProfileHeader(),
          _buildTabBar(),
        ],
        body: _buildTabContent(),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      pinned: true,
      title: Obx(() {
        final user = Get.find<AuthController>().currentUser.value;
        return Text(user.displayName.isNotEmpty ? user.displayName : 'Profile');
      }),
      actions: [
        Obx(() {
          if (!controller.isOwnProfile) return const SizedBox.shrink();
          return IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          );
        }),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return SliverToBoxAdapter(
      child: Obx(() {
        final user = Get.find<AuthController>().currentUser.value;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Avatar
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
                user.displayName.isNotEmpty ? user.displayName : 'User',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              // Bio
              if (user.bio.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  user.bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
              const SizedBox(height: 16),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatItem('Recipes', user.recipesCount.toString()),
                  const SizedBox(width: 32),
                  _buildStatItem('Followers', user.followersCount.toString()),
                  const SizedBox(width: 32),
                  _buildStatItem('Following', user.followingCount.toString()),
                ],
              ),
              const SizedBox(height: 16),

              // Edit Profile Button (only for own profile)
              if (controller.isOwnProfile)
                RasoiButton.secondary(
                  text: 'Edit Profile',
                  icon: Icons.edit,
                  onPressed: () => Get.toNamed(AppRoutes.editProfile),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(
        child: Container(
          color: AppColors.background,
          child: Obx(
            () => TabBar(
              controller: null,
              onTap: controller.changeTab,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: [
                Tab(text: controller.isOwnProfile ? AppStrings.myRecipes : 'Recipes'),
                if (controller.isOwnProfile) const Tab(text: AppStrings.savedRecipes),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return Obx(() {
      if (controller.selectedTab.value == 0) {
        return _buildMyRecipesTab();
      }
      return _buildSavedRecipesTab();
    });
  }

  Widget _buildMyRecipesTab() {
    return Obx(() {
      if (controller.isLoadingMyRecipes.value) {
        return _buildLoadingGrid();
      }

      if (controller.myRecipes.isEmpty) {
        return _buildEmptyState(
          icon: Icons.restaurant_menu,
          title: 'No recipes yet',
          subtitle: controller.isOwnProfile
              ? 'Create your first recipe!'
              : 'This user hasn\'t shared any recipes yet',
          showButton: controller.isOwnProfile,
          buttonText: 'Create Recipe',
          onButtonPressed: () => Get.toNamed(AppRoutes.createRecipe),
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
        itemCount: controller.myRecipes.length,
        itemBuilder: (context, index) {
          final recipe = controller.myRecipes[index];
          return GestureDetector(
            onLongPress: controller.isOwnProfile ? () => _showRecipeOptions(recipe.recipeId) : null,
            child: RecipeCard(
              recipe: recipe,
              onTap: () => Get.toNamed(AppRoutes.recipeDetailPath(recipe.recipeId)),
            ),
          );
        },
      );
    });
  }

  Widget _buildSavedRecipesTab() {
    return Obx(() {
      if (controller.isLoadingSavedRecipes.value) {
        return _buildLoadingGrid();
      }

      if (controller.savedRecipes.isEmpty) {
        return _buildEmptyState(
          icon: Icons.bookmark_outline,
          title: 'No saved recipes',
          subtitle: 'Save recipes to cook them later',
          showButton: false,
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
          final recipe = controller.savedRecipes[index];
          return GestureDetector(
            onLongPress: () => _showUnsaveConfirmation(recipe.recipeId),
            child: RecipeCard(
              recipe: recipe,
              onTap: () => Get.toNamed(AppRoutes.recipeDetailPath(recipe.recipeId)),
            ),
          );
        },
      );
    });
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const RecipeCardShimmer(),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    bool showButton = false,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
          if (showButton && buttonText != null) ...[
            const SizedBox(height: 24),
            RasoiButton.primary(text: buttonText, onPressed: onButtonPressed ?? () {}),
          ],
        ],
      ),
    );
  }

  void _showRecipeOptions(String recipeId) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Recipe'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.createRecipe, parameters: {'id': recipeId});
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Delete Recipe', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Get.back();
                _confirmDelete(recipeId);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String recipeId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Recipe?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteRecipe(recipeId);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showUnsaveConfirmation(String recipeId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove from Saved?'),
        content: const Text('Remove this recipe from your saved collection?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.unsaveRecipe(recipeId);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

/// Tab bar delegate for persistent header
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _TabBarDelegate({required this.child});

  @override
  Widget build(context, shrinkOffset, overlapsContent) => child;

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
