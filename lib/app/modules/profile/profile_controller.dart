import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/models/recipe_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/user_service.dart';
import '../../data/services/recipe_service.dart';
import '../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final UserService _userService = Get.find<UserService>();
  final RecipeService _recipeService = Get.find<RecipeService>();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxList<RecipeModel> userRecipes = <RecipeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFollowing = false.obs;

  String? targetUserId;

  @override
  void onInit() {
    super.onInit();
    targetUserId = Get.arguments as String?;
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      String uidToFetch = targetUserId ?? _authService.currentUser.value?.uid ?? '';

      if (uidToFetch.isEmpty) {
        return;
      }

      // 1. Fetch User Data
      if (targetUserId == null) {
        // Viewing own profile
        user.value = _authService.appUser.value;

        // Refresh in background
        final result = await _userService.getUserProfile(uidToFetch);
        result.fold(
          (failure) => null, // Ignore error, use cached
          (fresh) => user.value = fresh,
        );
      } else {
        // Viewing other user
        final result = await _userService.getUserProfile(uidToFetch);
        result.fold(
          (failure) {
            Get.snackbar("Error", failure.message);
          },
          (fetchedUser) {
            user.value = fetchedUser;
          },
        );

        // Check follow status
        final currentUid = _authService.currentUser.value?.uid;
        if (currentUid != null) {
          final followResult = await _userService.isFollowing(currentUid, uidToFetch);
          followResult.fold((failure) => null, (following) => isFollowing.value = following);
        }
      }

      // 2. Fetch Recipes
      final recipesResult = await _recipeService.getRecipesByAuthor(uidToFetch);
      recipesResult.fold(
        (failure) {
          Get.snackbar("Error", "Failed to load recipes");
        },
        (recipes) {
          userRecipes.assignAll(recipes);
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFollow() async {
    if (targetUserId == null) return;

    final currentUid = _authService.currentUser.value?.uid;
    if (currentUid == null) return;

    try {
      if (isFollowing.value) {
        final result = await _userService.unfollowUser(currentUid, targetUserId!);
        result.fold((failure) => Get.snackbar("Error", failure.message), (_) {
          isFollowing.value = false;
          user.update((val) {
            val?.followerCount = (val.followerCount ?? 1) - 1;
          });
        });
      } else {
        final result = await _userService.followUser(currentUid, targetUserId!);
        result.fold((failure) => Get.snackbar("Error", failure.message), (_) {
          isFollowing.value = true;
          user.update((val) {
            val?.followerCount = (val.followerCount ?? 0) + 1;
          });
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update follow status");
    }
  }

  void openRecipe(RecipeModel recipe) {
    Get.toNamed(Routes.RECIPE_DETAILS, arguments: recipe);
  }

  bool get isOwnProfile =>
      targetUserId == null || targetUserId == _authService.currentUser.value?.uid;
}
