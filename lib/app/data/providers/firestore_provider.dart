import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/recipe_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/comment_model.dart';

/// Firestore Provider
/// Handles all Firebase Firestore operations
class FirestoreProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference<Map<String, dynamic>> get usersCollection => _firestore.collection('users');
  CollectionReference<Map<String, dynamic>> get recipesCollection =>
      _firestore.collection('recipes');
  CollectionReference<Map<String, dynamic>> get commentsCollection =>
      _firestore.collection('comments');
  CollectionReference<Map<String, dynamic>> get likesCollection => _firestore.collection('likes');
  CollectionReference<Map<String, dynamic>> get savedRecipesCollection =>
      _firestore.collection('savedRecipes');

  // ============================================
  // User Operations
  // ============================================

  /// Get user by ID
  Future<UserModel?> getUser(String userId) async {
    final doc = await usersCollection.doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  /// Create or update user
  Future<void> saveUser(UserModel user) async {
    await usersCollection.doc(user.userId).set(user.toJson());
  }

  /// Update user fields
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await usersCollection.doc(userId).update(data);
  }

  // ============================================
  // Recipe Operations
  // ============================================

  /// Get recipes with pagination
  Future<List<RecipeModel>> getRecipes({
    int limit = 20,
    DocumentSnapshot? startAfter,
    String? category,
    List<String>? dietaryTypes,
    String? authorId,
  }) async {
    Query<Map<String, dynamic>> query = recipesCollection
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    if (dietaryTypes != null && dietaryTypes.isNotEmpty) {
      query = query.where('dietaryTypes', arrayContainsAny: dietaryTypes);
    }

    if (authorId != null) {
      query = query.where('authorId', isEqualTo: authorId);
    }

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => RecipeModel.fromFirestore(doc)).toList();
  }

  /// Get single recipe by ID
  Future<RecipeModel?> getRecipe(String recipeId) async {
    final doc = await recipesCollection.doc(recipeId).get();
    if (!doc.exists) return null;
    return RecipeModel.fromFirestore(doc);
  }

  /// Create recipe
  Future<String> createRecipe(RecipeModel recipe) async {
    final docRef = await recipesCollection.add(recipe.toJson());

    // Update user's recipe count
    await usersCollection.doc(recipe.authorId).update({'recipesCount': FieldValue.increment(1)});

    return docRef.id;
  }

  /// Update recipe
  Future<void> updateRecipe(String recipeId, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await recipesCollection.doc(recipeId).update(data);
  }

  /// Delete recipe
  Future<void> deleteRecipe(String recipeId, String authorId) async {
    await recipesCollection.doc(recipeId).delete();

    // Update user's recipe count
    await usersCollection.doc(authorId).update({'recipesCount': FieldValue.increment(-1)});
  }

  /// Increment view count
  Future<void> incrementViewCount(String recipeId) async {
    await recipesCollection.doc(recipeId).update({'viewsCount': FieldValue.increment(1)});
  }

  // ============================================
  // Like Operations
  // ============================================

  /// Like a recipe
  Future<void> likeRecipe(String userId, String recipeId) async {
    final batch = _firestore.batch();

    // Add like document
    batch.set(likesCollection.doc('${userId}_$recipeId'), {
      'userId': userId,
      'recipeId': recipeId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Increment like count on recipe
    batch.update(recipesCollection.doc(recipeId), {'likesCount': FieldValue.increment(1)});

    await batch.commit();
  }

  /// Unlike a recipe
  Future<void> unlikeRecipe(String userId, String recipeId) async {
    final batch = _firestore.batch();

    // Remove like document
    batch.delete(likesCollection.doc('${userId}_$recipeId'));

    // Decrement like count on recipe
    batch.update(recipesCollection.doc(recipeId), {'likesCount': FieldValue.increment(-1)});

    await batch.commit();
  }

  /// Check if user liked a recipe
  Future<bool> isRecipeLiked(String userId, String recipeId) async {
    final doc = await likesCollection.doc('${userId}_$recipeId').get();
    return doc.exists;
  }

  /// Get liked recipe IDs for user
  Future<List<String>> getLikedRecipeIds(String userId) async {
    final snapshot = await likesCollection.where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => doc['recipeId'] as String).toList();
  }

  // ============================================
  // Save Operations
  // ============================================

  /// Save a recipe
  Future<void> saveRecipe(String userId, String recipeId) async {
    await savedRecipesCollection.doc('${userId}_$recipeId').set({
      'userId': userId,
      'recipeId': recipeId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Unsave a recipe
  Future<void> unsaveRecipe(String userId, String recipeId) async {
    await savedRecipesCollection.doc('${userId}_$recipeId').delete();
  }

  /// Check if recipe is saved by user
  Future<bool> isRecipeSaved(String userId, String recipeId) async {
    final doc = await savedRecipesCollection.doc('${userId}_$recipeId').get();
    return doc.exists;
  }

  /// Get saved recipe IDs for user
  Future<List<String>> getSavedRecipeIds(String userId) async {
    final snapshot = await savedRecipesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => doc['recipeId'] as String).toList();
  }

  // ============================================
  // Comment Operations
  // ============================================

  /// Get comments for a recipe
  Future<List<CommentModel>> getComments(String recipeId, {int limit = 20}) async {
    final snapshot = await commentsCollection
        .where('recipeId', isEqualTo: recipeId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => CommentModel.fromFirestore(doc)).toList();
  }

  /// Add a comment
  Future<String> addComment(CommentModel comment) async {
    final batch = _firestore.batch();

    // Add comment
    final docRef = commentsCollection.doc();
    batch.set(docRef, comment.toJson());

    // Increment comment count on recipe
    batch.update(recipesCollection.doc(comment.recipeId), {
      'commentsCount': FieldValue.increment(1),
    });

    await batch.commit();
    return docRef.id;
  }

  /// Delete a comment
  Future<void> deleteComment(String commentId, String recipeId) async {
    final batch = _firestore.batch();

    batch.delete(commentsCollection.doc(commentId));
    batch.update(recipesCollection.doc(recipeId), {'commentsCount': FieldValue.increment(-1)});

    await batch.commit();
  }

  // ============================================
  // Search Operations
  // ============================================

  /// Search recipes by title (simple prefix match)
  Future<List<RecipeModel>> searchRecipes(String query, {int limit = 20}) async {
    final queryLower = query.toLowerCase();
    final snapshot = await recipesCollection
        .orderBy('title')
        .startAt([queryLower])
        .endAt(['$queryLower\uf8ff'])
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => RecipeModel.fromFirestore(doc)).toList();
  }
}
