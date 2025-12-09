import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/recipe_model.dart';
import '../../routes/app_pages.dart';

class SearchController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController searchInputController = TextEditingController();
  final RxList<RecipeModel> searchResults = <RecipeModel>[].obs;
  final RxBool isLoading = false.obs;

  void searchRecipes(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;
    try {
      // Basic Firestore search (exact or prefix match limited)
      // For MVP we can just fetch recent and filter client side OR use startAt/endAt
      // Let's use simple startAt for now (case-sensitive unfortunately in Firestore without third-party)

      // A better approach for MVP without Algolia:
      // Search by exact category match OR title prefix

      QuerySnapshot snapshot = await _firestore
          .collection('recipes')
          .where('isPublished', isEqualTo: true)
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: query + 'z')
          .limit(20)
          .get();

      searchResults.assignAll(snapshot.docs.map((doc) => RecipeModel.fromDocument(doc)).toList());
    } catch (e) {
      print("Search error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void openRecipe(RecipeModel recipe) {
    Get.toNamed(Routes.RECIPE_DETAILS, arguments: recipe);
  }
}
