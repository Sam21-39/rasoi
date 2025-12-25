import 'package:get/get.dart';
import '../controllers/search_controller.dart';

/// Search Binding
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchViewController>(() => SearchViewController());
  }
}
