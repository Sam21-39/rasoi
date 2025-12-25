import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/recipe_detail_controller.dart';
import '../../../../core/constants/app_colors.dart';

/// Recipe Detail View
class RecipeDetailView extends GetView<RecipeDetailController> {
  const RecipeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.recipe.value.isEmpty) {
          return const Center(child: Text('Recipe not found'));
        }

        return const Center(child: Text('Recipe detail view coming soon...'));
      }),
    );
  }
}
