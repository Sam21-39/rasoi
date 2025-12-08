import 'package:get/get.dart';
import '../../data/models/recipe_model.dart';

class RecipeDetailController extends GetxController {
  final Rx<RecipeModel?> recipe = Rx<RecipeModel?>(null);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is RecipeModel) {
      recipe.value = Get.arguments as RecipeModel;
    }
  }

  void toggleLike() {
    // TODO: Implement toggle like in Firestore
    if (recipe.value != null) {
      // Optimistic update
      // For MVP just local toggle logic visual
      // Real implementation requires user ID check and Firestore update
    }
  }

  void shareRecipe() {
    // TODO: Implement Share
    // Share.share(...);
  }
}
