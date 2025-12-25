import 'package:get/get.dart';
import '../controllers/create_recipe_controller.dart';

/// Create Recipe Binding
class CreateRecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateRecipeController>(() => CreateRecipeController());
  }
}
