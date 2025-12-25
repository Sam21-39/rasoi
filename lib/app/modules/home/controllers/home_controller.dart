import 'package:get/get.dart';

import '../../../data/models/recipe_model.dart';

/// Home Controller
/// Manages home feed state and recipe loading
class HomeController extends GetxController {
  static HomeController get to => Get.find<HomeController>();

  // Observable state
  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  final RxList<RecipeModel> popularRecipes = <RecipeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString selectedCategory = ''.obs;
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

      // TODO: Implement Firestore fetch
      // For now, we'll just add some delay to simulate loading
      await Future.delayed(const Duration(seconds: 1));

      // Placeholder: Add dummy data when implemented

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }

  /// Load more recipes for pagination
  Future<void> loadMoreRecipes() async {
    if (!hasMore || isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;

      // TODO: Implement pagination
      await Future.delayed(const Duration(milliseconds: 500));

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

    // TODO: Sync with Firebase
  }

  /// Toggle save on a recipe
  Future<void> toggleSave(String recipeId) async {
    final index = recipes.indexWhere((r) => r.recipeId == recipeId);
    if (index == -1) return;

    final recipe = recipes[index];

    // Optimistic update
    recipes[index] = recipe.copyWith(isSaved: !recipe.isSaved);

    // TODO: Sync with Firebase and local DB
  }
}
