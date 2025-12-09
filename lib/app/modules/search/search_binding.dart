import 'package:get/get.dart';
import 'search_controller.dart' as app;

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<app.SearchController>(() => app.SearchController());
  }
}
