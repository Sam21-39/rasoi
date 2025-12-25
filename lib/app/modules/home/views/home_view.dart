import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/rasoi_chip.dart';
import '../../../../core/widgets/recipe_card.dart';

/// Home View
/// Main feed displaying recipes
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshFeed,
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              // App Bar
              _buildAppBar(),

              // Search Bar
              SliverToBoxAdapter(child: _buildSearchBar()),

              // Categories
              SliverToBoxAdapter(child: _buildCategories()),

              // Recipes Grid
              _buildRecipeGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text('🍳', style: TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          const Text(
            'Rasoi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.textSecondary,
          onPressed: () {
            // TODO: Navigate to notifications
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.search),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Text(
                AppStrings.searchHint,
                style: TextStyle(color: AppColors.textHint, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => RasoiChipGroup(
            items: AppConstants.categories,
            selectedItem: controller.selectedCategory.value.isEmpty
                ? null
                : controller.selectedCategory.value,
            onSelected: controller.filterByCategory,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRecipeGrid() {
    return Obx(() {
      if (controller.isLoading.value && controller.recipes.isEmpty) {
        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => const RecipeCardShimmer(),
              childCount: 6,
            ),
          ),
        );
      }

      if (controller.recipes.isEmpty) {
        return SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState());
      }

      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final recipe = controller.recipes[index];
            return RecipeCard(
              recipe: recipe,
              onTap: () => Get.toNamed(AppRoutes.recipeDetailPath(recipe.recipeId)),
              onLikeTap: () => controller.toggleLike(recipe.recipeId),
              onSaveTap: () => controller.toggleSave(recipe.recipeId),
            );
          }, childCount: controller.recipes.length),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
              child: const Center(child: Text('🍳', style: TextStyle(fontSize: 60))),
            ),
            const SizedBox(height: 24),
            const Text(
              AppStrings.noRecipesFound,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Be the first to share a recipe!',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.createRecipe),
              icon: const Icon(Icons.add),
              label: const Text(AppStrings.addRecipe),
            ),
          ],
        ),
      ),
    );
  }
}
