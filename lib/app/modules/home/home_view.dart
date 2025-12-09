import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../../global_widgets/recipe_card.dart';
import '../../routes/app_pages.dart';
import '../../core/theme/app_theme.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rasoi Feed', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(onPressed: () => Get.toNamed(Routes.SEARCH), icon: const Icon(Icons.search)),
          IconButton(onPressed: () => Get.toNamed(Routes.PROFILE), icon: const Icon(Icons.person)),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.recipes.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.recipes.isEmpty) {
          // Empty State
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.restaurant_menu, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                const Text("No recipes yet", style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: controller.fetchRecipes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Refresh"),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchRecipes,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.recipes.length,
            itemBuilder: (context, index) {
              final recipe = controller.recipes[index];
              return RecipeCard(recipe: recipe, onTap: () => controller.openRecipeDetails(recipe));
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Create Recipe
          Get.toNamed(Routes.CREATE_RECIPE);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
