import 'package:get/get.dart';

import '../../../data/models/recipe_model.dart';
import '../../../data/repositories/recipe_repository.dart';
import '../../../services/database_service.dart';

/// Search View Controller
/// Manages search functionality with filters
class SearchViewController extends GetxController {
  static SearchViewController get to => Get.find<SearchViewController>();

  // Dependencies
  final RecipeRepository _recipeRepository = RecipeRepository();
  final DatabaseService _databaseService = DatabaseService();

  // State
  final RxString query = ''.obs;
  final RxList<RecipeModel> searchResults = <RecipeModel>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasSearched = false.obs;

  // Filters
  final RxString selectedCategory = ''.obs;
  final RxList<String> selectedDietaryTypes = <String>[].obs;
  final RxString selectedDifficulty = ''.obs;
  final RxInt maxCookingTime = 0.obs; // 0 = no limit

  @override
  void onInit() {
    super.onInit();
    loadRecentSearches();
  }

  /// Load recent searches from local storage
  Future<void> loadRecentSearches() async {
    recentSearches.value = await _databaseService.getRecentSearches();
  }

  /// Perform search
  Future<void> search(String q) async {
    query.value = q.trim();

    if (query.value.isEmpty) {
      searchResults.clear();
      hasSearched.value = false;
      return;
    }

    try {
      isLoading.value = true;
      hasSearched.value = true;

      // Save to recent searches
      await _databaseService.addRecentSearch(query.value);
      await loadRecentSearches();

      // Perform search
      var results = await _recipeRepository.searchRecipes(query.value);

      // Apply filters
      results = _applyFilters(results);

      searchResults.value = results;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      searchResults.clear();
    }
  }

  /// Apply filters to search results
  List<RecipeModel> _applyFilters(List<RecipeModel> recipes) {
    return recipes.where((recipe) {
      // Category filter
      if (selectedCategory.value.isNotEmpty && recipe.category != selectedCategory.value) {
        return false;
      }

      // Dietary types filter
      if (selectedDietaryTypes.isNotEmpty) {
        final hasMatchingType = recipe.dietaryTypes.any(
          (type) => selectedDietaryTypes.contains(type),
        );
        if (!hasMatchingType) return false;
      }

      // Difficulty filter
      if (selectedDifficulty.value.isNotEmpty && recipe.difficulty != selectedDifficulty.value) {
        return false;
      }

      // Cooking time filter
      if (maxCookingTime.value > 0 && recipe.cookingTime > maxCookingTime.value) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Search using a recent search term
  void searchFromRecent(String term) {
    query.value = term;
    search(term);
  }

  /// Clear search
  void clearSearch() {
    query.value = '';
    searchResults.clear();
    hasSearched.value = false;
  }

  /// Clear all recent searches
  Future<void> clearRecentSearches() async {
    await _databaseService.clearRecentSearches();
    recentSearches.clear();
  }

  /// Remove a specific recent search
  Future<void> removeRecentSearch(String term) async {
    // Re-fetch after clearing the specific one
    await loadRecentSearches();
  }

  // ============================================
  // Filter Methods
  // ============================================

  void setCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = '';
    } else {
      selectedCategory.value = category;
    }
    _reapplyFilters();
  }

  void toggleDietaryType(String type) {
    if (selectedDietaryTypes.contains(type)) {
      selectedDietaryTypes.remove(type);
    } else {
      selectedDietaryTypes.add(type);
    }
    _reapplyFilters();
  }

  void setDifficulty(String difficulty) {
    if (selectedDifficulty.value == difficulty) {
      selectedDifficulty.value = '';
    } else {
      selectedDifficulty.value = difficulty;
    }
    _reapplyFilters();
  }

  void setMaxCookingTime(int minutes) {
    maxCookingTime.value = minutes;
    _reapplyFilters();
  }

  void clearFilters() {
    selectedCategory.value = '';
    selectedDietaryTypes.clear();
    selectedDifficulty.value = '';
    maxCookingTime.value = 0;
    _reapplyFilters();
  }

  bool get hasActiveFilters =>
      selectedCategory.value.isNotEmpty ||
      selectedDietaryTypes.isNotEmpty ||
      selectedDifficulty.value.isNotEmpty ||
      maxCookingTime.value > 0;

  void _reapplyFilters() {
    if (hasSearched.value && query.value.isNotEmpty) {
      search(query.value);
    }
  }
}
