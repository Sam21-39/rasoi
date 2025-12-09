import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../data/services/recipe_service.dart';
import '../../data/services/seeding_service.dart';
import '../../data/models/recipe_model.dart';
import '../../data/services/ad_service.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final RecipeService _recipeService = Get.find<RecipeService>();
  final AdService _adService = Get.find<AdService>();

  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;

  final Rx<BannerAd?> bannerAd = Rx<BannerAd?>(null);

  // TODO: Add ScrollController for pagination

  @override
  void onInit() {
    super.onInit();
    Get.find<SeedingService>().seedData();
    fetchRecipes();
    _loadBannerAd();
  }

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

  @override
  void onClose() {
    bannerAd.value?.dispose();
    super.onClose();
  }
}
