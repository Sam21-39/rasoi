import 'dart:io';
import 'package:get/get.dart';

import '../models/recipe_model.dart';
import '../providers/firestore_provider.dart';
import '../providers/storage_provider.dart';
import '../../modules/auth/controllers/auth_controller.dart';

/// Recipe Repository
/// Business logic layer for recipe operations
class RecipeRepository {
  final FirestoreProvider _firestoreProvider = FirestoreProvider();
  final StorageProvider _storageProvider = StorageProvider();

  // ============================================
  // Read Operations
  // ============================================

  /// Get paginated recipe feed
  Future<List<RecipeModel>> getRecipeFeed({
    int limit = 20,
    String? category,
    List<String>? dietaryTypes,
  }) async {
    final recipes = await _firestoreProvider.getRecipes(
      limit: limit,
      category: category,
      dietaryTypes: dietaryTypes,
    );

    // Fetch like/save status for current user
    return await _enrichRecipesWithUserStatus(recipes);
  }

  /// Get single recipe with full details
  Future<RecipeModel?> getRecipeDetails(String recipeId) async {
    final recipe = await _firestoreProvider.getRecipe(recipeId);
    if (recipe == null) return null;

    // Increment view count
    await _firestoreProvider.incrementViewCount(recipeId);

    // Enrich with user status
    return await _enrichRecipeWithUserStatus(recipe);
  }

  /// Get recipes by author
  Future<List<RecipeModel>> getRecipesByAuthor(String authorId) async {
    final recipes = await _firestoreProvider.getRecipes(authorId: authorId);
    return await _enrichRecipesWithUserStatus(recipes);
  }

  /// Get saved recipes for current user
  Future<List<RecipeModel>> getSavedRecipes() async {
    final userId = _getCurrentUserId();
    if (userId == null) return [];

    final recipeIds = await _firestoreProvider.getSavedRecipeIds(userId);
    final recipes = <RecipeModel>[];

    for (final id in recipeIds) {
      final recipe = await _firestoreProvider.getRecipe(id);
      if (recipe != null) {
        recipes.add(recipe.copyWith(isSaved: true));
      }
    }

    return recipes;
  }

  /// Search recipes
  Future<List<RecipeModel>> searchRecipes(String query) async {
    final recipes = await _firestoreProvider.searchRecipes(query);
    return await _enrichRecipesWithUserStatus(recipes);
  }

  // ============================================
  // Write Operations
  // ============================================

  /// Create a new recipe
  Future<String> createRecipe(RecipeModel recipe, File imageFile) async {
    // Upload main image
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final imageUrl = await _storageProvider.uploadRecipeImage(imageFile, tempId);

    // Create recipe with image URL
    final recipeWithImage = recipe.copyWith(
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final recipeId = await _firestoreProvider.createRecipe(recipeWithImage);
    return recipeId;
  }

  /// Update an existing recipe
  Future<void> updateRecipe(String recipeId, Map<String, dynamic> updates, {File? newImage}) async {
    if (newImage != null) {
      final imageUrl = await _storageProvider.uploadRecipeImage(newImage, recipeId);
      updates['imageUrl'] = imageUrl;
    }

    await _firestoreProvider.updateRecipe(recipeId, updates);
  }

  /// Delete a recipe
  Future<void> deleteRecipe(String recipeId, String authorId) async {
    await _firestoreProvider.deleteRecipe(recipeId, authorId);
    await _storageProvider.deleteRecipeImages(recipeId);
  }

  // ============================================
  // Interaction Operations
  // ============================================

  /// Toggle like on a recipe
  Future<bool> toggleLike(String recipeId) async {
    final userId = _getCurrentUserId();
    if (userId == null) return false;

    final isLiked = await _firestoreProvider.isRecipeLiked(userId, recipeId);

    if (isLiked) {
      await _firestoreProvider.unlikeRecipe(userId, recipeId);
      return false;
    } else {
      await _firestoreProvider.likeRecipe(userId, recipeId);
      return true;
    }
  }

  /// Toggle save on a recipe
  Future<bool> toggleSave(String recipeId) async {
    final userId = _getCurrentUserId();
    if (userId == null) return false;

    final isSaved = await _firestoreProvider.isRecipeSaved(userId, recipeId);

    if (isSaved) {
      await _firestoreProvider.unsaveRecipe(userId, recipeId);
      return false;
    } else {
      await _firestoreProvider.saveRecipe(userId, recipeId);
      return true;
    }
  }

  // ============================================
  // Helper Methods
  // ============================================

  String? _getCurrentUserId() {
    try {
      return Get.find<AuthController>().userId;
    } catch (e) {
      return null;
    }
  }

  Future<RecipeModel> _enrichRecipeWithUserStatus(RecipeModel recipe) async {
    final userId = _getCurrentUserId();
    if (userId == null) return recipe;

    final isLiked = await _firestoreProvider.isRecipeLiked(userId, recipe.recipeId);
    final isSaved = await _firestoreProvider.isRecipeSaved(userId, recipe.recipeId);

    return recipe.copyWith(isLiked: isLiked, isSaved: isSaved);
  }

  Future<List<RecipeModel>> _enrichRecipesWithUserStatus(List<RecipeModel> recipes) async {
    final userId = _getCurrentUserId();
    if (userId == null) return recipes;

    final likedIds = await _firestoreProvider.getLikedRecipeIds(userId);
    final savedIds = await _firestoreProvider.getSavedRecipeIds(userId);

    return recipes.map((recipe) {
      return recipe.copyWith(
        isLiked: likedIds.contains(recipe.recipeId),
        isSaved: savedIds.contains(recipe.recipeId),
      );
    }).toList();
  }
}
