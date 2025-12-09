import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/recipe_service.dart';
import '../services/seeding_service.dart';
import '../services/storage_service.dart';
import '../services/user_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.lazyPut<RecipeService>(() => RecipeService(), fenix: true);
    Get.put<SeedingService>(SeedingService());
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
    Get.lazyPut<UserService>(() => UserService(), fenix: true);
  }
}
