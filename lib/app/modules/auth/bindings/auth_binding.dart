import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// Auth Binding
/// Dependency injection for authentication module
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
