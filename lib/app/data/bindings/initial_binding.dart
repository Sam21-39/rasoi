import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/recipe_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.lazyPut<RecipeService>(() => RecipeService(), fenix: true);
  }
}
