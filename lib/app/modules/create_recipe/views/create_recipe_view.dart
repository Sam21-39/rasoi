import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/create_recipe_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Create Recipe View
class CreateRecipeView extends GetView<CreateRecipeController> {
  const CreateRecipeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.createRecipe),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
      ),
      body: Column(
        children: [
          // Step Indicator
          Obx(() => _buildStepIndicator()),

          // Content
          Expanded(
            child: Center(
              child: Text(
                'Recipe creation form coming soon...',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = [
      AppStrings.basicInfo,
      AppStrings.addIngredients,
      AppStrings.addInstructions,
      AppStrings.reviewPublish,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = controller.currentStep.value >= index;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: isActive ? AppColors.primary : AppColors.border),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (index < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: controller.currentStep.value > index
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
