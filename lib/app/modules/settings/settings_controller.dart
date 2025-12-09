import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_pages.dart';

class SettingsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool pushNotificationsEnabled = true.obs;
  final RxBool emailNotificationsEnabled = false.obs;

  void togglePushNotifications(bool val) {
    pushNotificationsEnabled.value = val;
    // In real app, update settings in Firestore or local storage
  }

  void toggleEmailNotifications(bool val) {
    emailNotificationsEnabled.value = val;
  }

  void logout() async {
    await _authService.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
