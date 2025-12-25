import 'package:get/get.dart';
import '../../../data/models/recipe_model.dart';

/// Profile Controller
class ProfileController extends GetxController {
  final RxList<RecipeModel> myRecipes = <RecipeModel>[].obs;
  final RxList<RecipeModel> savedRecipes = <RecipeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadMyRecipes();
    loadSavedRecipes();
  }

  Future<void> loadMyRecipes() async {
    isLoading.value = true;
    // TODO: Fetch from Firestore
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  Future<void> loadSavedRecipes() async {
    // TODO: Fetch from local DB + Firestore
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
