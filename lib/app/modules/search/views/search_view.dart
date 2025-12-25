import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/search_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/rasoi_text_field.dart';
import '../../../../core/widgets/rasoi_chip.dart';
import '../../../../core/widgets/recipe_card.dart';

/// Search View
/// Full search screen with filters
class SearchView extends GetView<SearchViewController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          Obx(
            () => controller.hasActiveFilters
                ? IconButton(
                    icon: const Icon(Icons.filter_alt_off),
                    onPressed: controller.clearFilters,
                    tooltip: 'Clear filters',
                  )
                : IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: () => _showFiltersSheet(context),
                    tooltip: 'Filters',
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(16),
            child: RasoiSearchField(
              hint: AppStrings.searchHint,
              autofocus: true,
              onChanged: (value) {
                if (value.length >= 2) {
                  controller.search(value);
                }
              },
              onSubmitted: controller.search,
              onClear: controller.clearSearch,
            ),
          ),

          // Active Filters
          Obx(() {
            if (!controller.hasActiveFilters) return const SizedBox.shrink();
            return _buildActiveFilters();
          }),

          // Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!controller.hasSearched.value) {
                return _buildRecentSearches();
              }

              if (controller.searchResults.isEmpty) {
                return _buildNoResults();
              }

              return _buildSearchResults();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (controller.selectedCategory.value.isNotEmpty)
              _buildFilterChip(
                controller.selectedCategory.value,
                () => controller.setCategory(controller.selectedCategory.value),
              ),
            ...controller.selectedDietaryTypes.map(
              (type) => _buildFilterChip(type, () => controller.toggleDietaryType(type)),
            ),
            if (controller.selectedDifficulty.value.isNotEmpty)
              _buildFilterChip(
                controller.selectedDifficulty.value,
                () => controller.setDifficulty(controller.selectedDifficulty.value),
              ),
            if (controller.maxCookingTime.value > 0)
              _buildFilterChip(
                '≤${controller.maxCookingTime.value} min',
                () => controller.setMaxCookingTime(0),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: onRemove,
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        deleteIconColor: AppColors.primary,
        labelStyle: const TextStyle(color: AppColors.primary),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Obx(() {
      if (controller.recentSearches.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 64, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              Text(
                'Search for recipes',
                style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                'Try "Butter Chicken" or "Biryani"',
                style: TextStyle(color: AppColors.textHint),
              ),
            ],
          ),
        );
      }

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.recentSearches,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextButton(onPressed: controller.clearRecentSearches, child: const Text('Clear All')),
            ],
          ),
          const SizedBox(height: 8),
          ...controller.recentSearches.map(
            (term) => ListTile(
              leading: const Icon(Icons.history),
              title: Text(term),
              onTap: () => controller.searchFromRecent(term),
              trailing: IconButton(
                icon: const Icon(Icons.north_west),
                onPressed: () => controller.searchFromRecent(term),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            AppStrings.noRecipesFound,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or filters',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          if (controller.hasActiveFilters) ...[
            const SizedBox(height: 16),
            TextButton(onPressed: controller.clearFilters, child: const Text('Clear filters')),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final recipe = controller.searchResults[index];
        return RecipeCard(
          recipe: recipe,
          onTap: () => Get.toNamed(AppRoutes.recipeDetailPath(recipe.recipeId)),
        );
      },
    );
  }

  void _showFiltersSheet(BuildContext context) {
    Get.bottomSheet(_FiltersBottomSheet(controller: controller), isScrollControlled: true);
  }
}

/// Filters Bottom Sheet
class _FiltersBottomSheet extends StatelessWidget {
  final SearchViewController controller;

  const _FiltersBottomSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  controller.clearFilters();
                  Get.back();
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Category
          const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.categories.map((cat) {
                return RasoiChip(
                  label: cat,
                  isSelected: controller.selectedCategory.value == cat,
                  onTap: () => controller.setCategory(cat),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Dietary Type
          const Text('Dietary Type', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.dietaryTypes.map((type) {
                final isSelected = controller.selectedDietaryTypes.contains(type);
                return RasoiChip(
                  label: type,
                  isSelected: isSelected,
                  showCheckIcon: isSelected,
                  onTap: () => controller.toggleDietaryType(type),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Difficulty
          const Text('Difficulty', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.difficultyLevels.map((level) {
                return RasoiChip(
                  label: level,
                  isSelected: controller.selectedDifficulty.value == level,
                  onTap: () => controller.setDifficulty(level),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Cooking Time
          const Text('Max Cooking Time', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [15, 30, 45, 60, 90].map((min) {
                return RasoiChip(
                  label: '$min min',
                  isSelected: controller.maxCookingTime.value == min,
                  onTap: () => controller.setMaxCookingTime(min),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () => Get.back(), child: const Text('Apply Filters')),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
