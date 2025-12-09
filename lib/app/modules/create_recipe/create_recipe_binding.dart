import 'package:get/get.dart';
import 'create_recipe_controller.dart';

class CreateRecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateRecipeController>(() => CreateRecipeController());
  }
}
