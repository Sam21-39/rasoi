import 'package:get/get.dart';
import '../../../data/models/recipe_model.dart';

/// Recipe Detail Controller
class RecipeDetailController extends GetxController {
  final Rx<RecipeModel> recipe = RecipeModel.empty().obs;
  final RxBool isLoading = false.obs;

  String get recipeId => Get.parameters['id'] ?? '';

  @override
  void onInit() {
    super.onInit();
    loadRecipe();
  }

  Future<void> loadRecipe() async {
    if (recipeId.isEmpty) return;

    isLoading.value = true;
    // TODO: Fetch recipe from Firestore
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }
}
