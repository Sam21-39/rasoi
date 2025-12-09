import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/recipe_service.dart';
import '../services/seeding_service.dart';
import '../services/storage_service.dart';
import '../services/user_service.dart';
import '../services/permission_service.dart';
import '../services/notification_service.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/language_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.lazyPut<RecipeService>(() => RecipeService(), fenix: true);
    Get.put<SeedingService>(SeedingService());
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
    Get.lazyPut<UserService>(() => UserService(), fenix: true);
    Get.put<PermissionService>(PermissionService());
    Get.put<NotificationService>(NotificationService());

    // Controllers
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<LanguageController>(LanguageController(), permanent: true);

    // Get.putAsync<AdService>(() => AdService().init()); // Disabled for now
  }
}
