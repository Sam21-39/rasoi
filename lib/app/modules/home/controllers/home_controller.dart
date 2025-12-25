import 'package:get/get.dart';

import '../../../data/models/recipe_model.dart';
import '../../../data/repositories/recipe_repository.dart';
import '../../../services/database_service.dart';

/// Home Controller
/// Manages home feed state and recipe loading
class HomeController extends GetxController {
  static HomeController get to => Get.find<HomeController>();

  // Dependencies
  final RecipeRepository _recipeRepository = RecipeRepository();
  final DatabaseService _databaseService = DatabaseService();

  // Observable state
  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  final RxList<RecipeModel> popularRecipes = <RecipeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString selectedCategory = ''.obs;
  final RxList<String> selectedDietaryTypes = <String>[].obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentNavIndex = 0.obs;

  // Pagination
  static const int _pageSize = 20;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    loadRecipes();
  }

  /// Load recipes from Firestore
  Future<void> loadRecipes({bool refresh = false}) async {
    if (refresh) {
      hasMore = true;
      recipes.clear();
    }

    if (!hasMore || isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedRecipes = await _recipeRepository.getRecipeFeed(
        limit: _pageSize,
        category: selectedCategory.value.isEmpty ? null : selectedCategory.value,
        dietaryTypes: selectedDietaryTypes.isEmpty ? null : selectedDietaryTypes.toList(),
      );

      if (fetchedRecipes.length < _pageSize) {
        hasMore = false;
      }

      recipes.addAll(fetchedRecipes);

      // Cache recipes for offline use
      await _databaseService.cacheRecipes(fetchedRecipes);

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();

      // Try to load from cache if network fails
      if (recipes.isEmpty) {
        final cachedRecipes = await _databaseService.getCachedRecipes();
        if (cachedRecipes.isNotEmpty) {
          recipes.addAll(cachedRecipes);
          errorMessage.value = 'Showing cached recipes. Pull to refresh.';
        }
      }
    }
  }

  /// Load more recipes for pagination
  Future<void> loadMoreRecipes() async {
    if (!hasMore || isLoadingMore.value || isLoading.value) return;

    try {
      isLoadingMore.value = true;

      final fetchedRecipes = await _recipeRepository.getRecipeFeed(
        limit: _pageSize,
        category: selectedCategory.value.isEmpty ? null : selectedCategory.value,
        dietaryTypes: selectedDietaryTypes.isEmpty ? null : selectedDietaryTypes.toList(),
      );

      if (fetchedRecipes.length < _pageSize) {
        hasMore = false;
      }

      recipes.addAll(fetchedRecipes);
      isLoadingMore.value = false;
    } catch (e) {
      isLoadingMore.value = false;
    }
  }

  /// Filter by category
  void filterByCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = '';
    } else {
      selectedCategory.value = category;
    }
    loadRecipes(refresh: true);
  }

  /// Filter by dietary types
  void filterByDietaryTypes(List<String> types) {
    selectedDietaryTypes.value = types;
    loadRecipes(refresh: true);
  }

  /// Refresh feed
  Future<void> refreshFeed() async {
    await loadRecipes(refresh: true);
  }

  /// Change bottom nav index
  void changeNavIndex(int index) {
    currentNavIndex.value = index;
  }

  /// Toggle like on a recipe
  Future<void> toggleLike(String recipeId) async {
    final index = recipes.indexWhere((r) => r.recipeId == recipeId);
    if (index == -1) return;

    final recipe = recipes[index];
    final newLikeStatus = !recipe.isLiked;
    final newLikeCount = recipe.likesCount + (newLikeStatus ? 1 : -1);

    // Optimistic update
    recipes[index] = recipe.copyWith(isLiked: newLikeStatus, likesCount: newLikeCount);

    try {
      await _recipeRepository.toggleLike(recipeId);
    } catch (e) {
      // Revert on error
      recipes[index] = recipe;
      Get.snackbar('Error', 'Failed to update like');
    }
  }

  /// Toggle save on a recipe
  Future<void> toggleSave(String recipeId) async {
    final index = recipes.indexWhere((r) => r.recipeId == recipeId);
    if (index == -1) return;

    final recipe = recipes[index];
    final newSaveStatus = !recipe.isSaved;

    // Optimistic update
    recipes[index] = recipe.copyWith(isSaved: newSaveStatus);

    try {
      await _recipeRepository.toggleSave(recipeId);

      // Update local database
      if (newSaveStatus) {
        await _databaseService.saveRecipeLocally(recipes[index]);
      } else {
        await _databaseService.removeLocalRecipe(recipeId);
      }
    } catch (e) {
      // Revert on error
      recipes[index] = recipe;
      Get.snackbar('Error', 'Failed to save recipe');
    }
  }

  /// Clear all filters
  void clearFilters() {
    selectedCategory.value = '';
    selectedDietaryTypes.clear();
    loadRecipes(refresh: true);
  }
}
