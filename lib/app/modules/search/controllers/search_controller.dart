import 'package:get/get.dart';

/// Search View Controller
class SearchViewController extends GetxController {
  final RxString query = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<String> recentSearches = <String>[].obs;

  void search(String q) {
    query.value = q;
    // TODO: Implement search
  }

  void clearSearch() {
    query.value = '';
  }
}
