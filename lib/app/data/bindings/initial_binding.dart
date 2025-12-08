import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/recipe_service.dart';
import '../services/seeding_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.lazyPut<RecipeService>(() => RecipeService(), fenix: true);
    // Initialize SeedingService and run seed (could be moved to main or splash in production)
    Get.put<SeedingService>(SeedingService()).seedData();
  }
}
