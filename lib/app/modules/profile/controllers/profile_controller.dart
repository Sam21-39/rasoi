import 'package:get/get.dart';

import '../../../data/models/recipe_model.dart';
import '../../../data/repositories/recipe_repository.dart';
import '../../../services/database_service.dart';
import '../../auth/controllers/auth_controller.dart';

/// Profile Controller
/// Manages user profile, my recipes, and saved recipes
class ProfileController extends GetxController {
  static ProfileController get to => Get.find<ProfileController>();

  // Dependencies
  final RecipeRepository _recipeRepository = RecipeRepository();
  final DatabaseService _databaseService = DatabaseService();

  // State
  final RxList<RecipeModel> myRecipes = <RecipeModel>[].obs;
  final RxList<RecipeModel> savedRecipes = <RecipeModel>[].obs;
  final RxBool isLoadingMyRecipes = false.obs;
  final RxBool isLoadingSavedRecipes = false.obs;
  final RxInt selectedTab = 0.obs;

  // User being viewed (for other user profiles)
  String? viewingUserId;

  @override
  void onInit() {
    super.onInit();
    viewingUserId = Get.parameters['id'];
    loadMyRecipes();
    loadSavedRecipes();
  }

  /// Get the user ID to display
  String get displayUserId {
    if (viewingUserId != null) return viewingUserId!;
    return Get.find<AuthController>().userId;
  }

  /// Check if viewing own profile
  bool get isOwnProfile {
    return viewingUserId == null || viewingUserId == Get.find<AuthController>().userId;
  }

  /// Load user's recipes
  Future<void> loadMyRecipes() async {
    try {
      isLoadingMyRecipes.value = true;
      myRecipes.value = await _recipeRepository.getRecipesByAuthor(displayUserId);
      isLoadingMyRecipes.value = false;
    } catch (e) {
      isLoadingMyRecipes.value = false;
    }
  }

  /// Load saved recipes (only for own profile)
  Future<void> loadSavedRecipes() async {
    if (!isOwnProfile) return;

    try {
      isLoadingSavedRecipes.value = true;

      // Try online first
      try {
        savedRecipes.value = await _recipeRepository.getSavedRecipes();
      } catch (e) {
        // Fall back to local
        savedRecipes.value = await _databaseService.getLocalSavedRecipes();
      }

      isLoadingSavedRecipes.value = false;
    } catch (e) {
      isLoadingSavedRecipes.value = false;
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await Future.wait([loadMyRecipes(), loadSavedRecipes()]);
  }

  /// Change tab
  void changeTab(int index) {
    selectedTab.value = index;
  }

  /// Delete a recipe
  Future<bool> deleteRecipe(String recipeId) async {
    try {
      await _recipeRepository.deleteRecipe(recipeId, Get.find<AuthController>().userId);
      myRecipes.removeWhere((r) => r.recipeId == recipeId);
      Get.snackbar('Success', 'Recipe deleted');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete recipe');
      return false;
    }
  }

  /// Unsave a recipe
  Future<void> unsaveRecipe(String recipeId) async {
    try {
      await _recipeRepository.toggleSave(recipeId);
      await _databaseService.removeLocalRecipe(recipeId);
      savedRecipes.removeWhere((r) => r.recipeId == recipeId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to unsave recipe');
    }
  }
}
