import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/recipe_model.dart';

class RecipeService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch latest recipes for Home Feed with pagination
  Future<List<RecipeModel>> getRecipes({int limit = 10, DocumentSnapshot? lastDocument}) async {
    Query query = _firestore
        .collection('recipes')
        .where('isPublished', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => RecipeModel.fromDocument(doc)).toList();
  }

  // Create a new recipe
  Future<void> createRecipe(RecipeModel recipe) async {
    await _firestore.collection('recipes').add(recipe.toMap());
  }

  // Get single recipe details
  Future<RecipeModel?> getRecipeById(String id) async {
    DocumentSnapshot doc = await _firestore.collection('recipes').doc(id).get();
    if (doc.exists) {
      return RecipeModel.fromDocument(doc);
    }
    return null;
  }
}
