import 'package:get/get.dart';
import '../../data/services/recipe_service.dart';
import '../../data/models/recipe_model.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final RecipeService _recipeService = Get.find<RecipeService>();

  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;

  // TODO: Add ScrollController for pagination

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      isLoading.value = true;
      // In a real app we would handle pagination page by page.
      // For MVP, just fetching top 10 descending.
      final newRecipes = await _recipeService.getRecipes(limit: 10);
      recipes.assignAll(newRecipes);
      // Logic for 'hasMore' would depend on last document snapshot
    } catch (e) {
      Get.snackbar("Error", "Failed to load recipes");
    } finally {
      isLoading.value = false;
    }
  }

  void openRecipeDetails(RecipeModel recipe) {
    Get.toNamed(Routes.RECIPE_DETAILS, arguments: recipe);
  }
}
