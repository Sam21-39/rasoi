import 'package:get/get.dart';

/// Create Recipe Controller
class CreateRecipeController extends GetxController {
  final RxInt currentStep = 0.obs;
  final RxBool isLoading = false.obs;

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }
}
