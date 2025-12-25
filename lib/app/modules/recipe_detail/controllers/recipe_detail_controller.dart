import 'package:get/get.dart';

import '../../../data/models/recipe_model.dart';
import '../../../data/models/comment_model.dart';
import '../../../data/repositories/recipe_repository.dart';
import '../../../data/providers/firestore_provider.dart';
import '../../../services/database_service.dart';
import '../../auth/controllers/auth_controller.dart';

/// Recipe Detail Controller
/// Manages recipe detail view state and interactions
class RecipeDetailController extends GetxController {
  static RecipeDetailController get to => Get.find<RecipeDetailController>();

  // Dependencies
  final RecipeRepository _recipeRepository = RecipeRepository();
  final FirestoreProvider _firestoreProvider = FirestoreProvider();
  final DatabaseService _databaseService = DatabaseService();

  // Observable state
  final Rx<RecipeModel> recipe = RecipeModel.empty().obs;
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingComments = false.obs;
  final RxBool isSubmittingComment = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentServings = 1.obs;
  final RxInt currentImageIndex = 0.obs;

  String get recipeId => Get.parameters['id'] ?? '';

  @override
  void onInit() {
    super.onInit();
    if (recipeId.isNotEmpty) {
      loadRecipe();
      loadComments();
    }
  }

  /// Load recipe details
  Future<void> loadRecipe() async {
    if (recipeId.isEmpty) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedRecipe = await _recipeRepository.getRecipeDetails(recipeId);

      if (fetchedRecipe != null) {
        recipe.value = fetchedRecipe;
        currentServings.value = fetchedRecipe.servings;
      } else {
        // Try loading from local cache
        final localRecipes = await _databaseService.getLocalSavedRecipes();
        final localRecipe = localRecipes.firstWhereOrNull((r) => r.recipeId == recipeId);
        if (localRecipe != null) {
          recipe.value = localRecipe;
          currentServings.value = localRecipe.servings;
        } else {
          errorMessage.value = 'Recipe not found';
        }
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }

  /// Load comments for recipe
  Future<void> loadComments() async {
    if (recipeId.isEmpty) return;

    try {
      isLoadingComments.value = true;
      comments.value = await _firestoreProvider.getComments(recipeId);
      isLoadingComments.value = false;
    } catch (e) {
      isLoadingComments.value = false;
    }
  }

  /// Add a comment
  Future<bool> addComment(String text) async {
    if (text.trim().isEmpty) return false;

    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn) {
      Get.snackbar('Error', 'Please sign in to comment');
      return false;
    }

    try {
      isSubmittingComment.value = true;

      final comment = CommentModel(
        commentId: '',
        recipeId: recipeId,
        userId: authController.userId,
        userName: authController.currentUser.value.displayName,
        userPhotoUrl: authController.currentUser.value.photoUrl,
        text: text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestoreProvider.addComment(comment);

      // Reload comments
      await loadComments();

      // Update comment count in recipe
      recipe.value = recipe.value.copyWith(commentsCount: recipe.value.commentsCount + 1);

      isSubmittingComment.value = false;
      return true;
    } catch (e) {
      isSubmittingComment.value = false;
      Get.snackbar('Error', 'Failed to add comment');
      return false;
    }
  }

  /// Delete a comment
  Future<void> deleteComment(String commentId) async {
    try {
      await _firestoreProvider.deleteComment(commentId, recipeId);
      comments.removeWhere((c) => c.commentId == commentId);
      recipe.value = recipe.value.copyWith(commentsCount: recipe.value.commentsCount - 1);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete comment');
    }
  }

  /// Toggle like
  Future<void> toggleLike() async {
    final newLikeStatus = !recipe.value.isLiked;
    final newLikeCount = recipe.value.likesCount + (newLikeStatus ? 1 : -1);

    // Optimistic update
    recipe.value = recipe.value.copyWith(isLiked: newLikeStatus, likesCount: newLikeCount);

    try {
      await _recipeRepository.toggleLike(recipeId);
    } catch (e) {
      // Revert on error
      recipe.value = recipe.value.copyWith(
        isLiked: !newLikeStatus,
        likesCount: recipe.value.likesCount - (newLikeStatus ? 1 : -1),
      );
    }
  }

  /// Toggle save
  Future<void> toggleSave() async {
    final newSaveStatus = !recipe.value.isSaved;

    // Optimistic update
    recipe.value = recipe.value.copyWith(isSaved: newSaveStatus);

    try {
      await _recipeRepository.toggleSave(recipeId);

      if (newSaveStatus) {
        await _databaseService.saveRecipeLocally(recipe.value);
        Get.snackbar('Saved', 'Recipe saved for offline access');
      } else {
        await _databaseService.removeLocalRecipe(recipeId);
      }
    } catch (e) {
      recipe.value = recipe.value.copyWith(isSaved: !newSaveStatus);
    }
  }

  /// Update servings (for ingredient calculations)
  void updateServings(int newServings) {
    if (newServings < 1) return;
    currentServings.value = newServings;
  }

  /// Get scaled ingredient quantity
  String getScaledQuantity(String originalQuantity) {
    if (recipe.value.servings == 0) return originalQuantity;

    try {
      final originalValue = double.tryParse(originalQuantity);
      if (originalValue == null) return originalQuantity;

      final scaleFactor = currentServings.value / recipe.value.servings;
      final scaledValue = originalValue * scaleFactor;

      // Format nicely
      if (scaledValue == scaledValue.roundToDouble()) {
        return scaledValue.round().toString();
      }
      return scaledValue.toStringAsFixed(1);
    } catch (e) {
      return originalQuantity;
    }
  }

  /// Share recipe
  Future<void> shareRecipe() async {
    // TODO: Implement share functionality
    Get.snackbar('Share', 'Share functionality coming soon');
  }

  /// Check if current user is author
  bool get isAuthor {
    final authController = Get.find<AuthController>();
    return authController.isLoggedIn && authController.userId == recipe.value.authorId;
  }
}
