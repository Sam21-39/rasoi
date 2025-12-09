import 'package:get/get.dart';
import '../../data/services/recipe_service.dart';
import '../../data/services/seeding_service.dart';
import '../../data/models/recipe_model.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final RecipeService _recipeService = Get.find<RecipeService>();
  final SeedingService _seedingService = Get.find<SeedingService>();

  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;

  // TODO: Add ScrollController for pagination
  // Ad logic disabled

  @override
  void onInit() {
    super.onInit();
    _seedingService.seedData(); // Check and seed if needed
    fetchRecipes();
  }

  /*
  void _loadBannerAd() {
    try {
      // createBannerAd returns a BannerAd?, so no need to cast if signature matches
      final ad = _adService.createBannerAd(
        onAdLoaded: (ad) {
          bannerAd.value = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          bannerAd.value = null;
          debugPrint("Ad failed to load: $error");
        },
      );
      bannerAd.value = ad;
      bannerAd.value?.load();
    } catch (e) {
      debugPrint("Ad setup failed: $e");
    }
  }
  */

  Future<void> fetchRecipes() async {
    try {
      isLoading.value = true;

      final result = await _recipeService.fetchRecipes(limit: 10);

      result.fold(
        (failure) {
          Get.snackbar("Error", failure.message);
        },
        (newRecipes) {
          recipes.assignAll(newRecipes);
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void openRecipeDetails(RecipeModel recipe) {
    Get.toNamed(Routes.RECIPE_DETAILS, arguments: recipe);
  }

  /*
  @override
  void onClose() {
    // bannerAd.value?.dispose();
    super.onClose();
  }
  */
}
