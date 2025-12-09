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

  // If null, we show current user's profile
  String? targetUserId;

  @override
  void onInit() {
    super.onInit();
    // Check arguments to see if viewing another user
    targetUserId = Get.arguments as String?;
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      String uidToFetch = targetUserId ?? _authService.currentUser.value?.uid ?? '';

      if (uidToFetch.isEmpty) {
        // Handle guest or error
        return;
      }

      // 1. Fetch User Data
      if (targetUserId == null) {
        // Viewing own profile - use cached appUser but verify fresh
        user.value = _authService.appUser.value;
        // Refresh it in bg
        // _authService.onInit(); // Re-trigger auth listener is wrong, just skip or rely on stream
        UserModel? fresh = await _userService.getUserProfile(uidToFetch);
        if (fresh != null) user.value = fresh;
      } else {
        // Viewing other
        user.value = await _userService.getUserProfile(uidToFetch);
        // Check follow status
        isFollowing.value = await _userService.isFollowing(uidToFetch);
      }

      // 2. Fetch Recipes
      final recipes = await _recipeService.getRecipesByAuthor(uidToFetch);
      userRecipes.assignAll(recipes);
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFollow() async {
    if (targetUserId == null) return; // Can't follow self (UI shouldn't show button)

    try {
      if (isFollowing.value) {
        await _userService.unfollowUser(targetUserId!);
        isFollowing.value = false;
        user.update((val) {
          val?.followerCount = (val.followerCount ?? 1) - 1;
        });
      } else {
        await _userService.followUser(targetUserId!);
        isFollowing.value = true;
        user.update((val) {
          val?.followerCount = (val.followerCount ?? 0) + 1;
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
