import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../models/recipe_model.dart';
import '../../core/errors/recipe_failures.dart';
import '../../core/services/logger_service.dart';
import '../../core/constants/firestore_constants.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoggerService _logger = LoggerService();

  /// Fetch all recipes with pagination
  Future<Either<RecipeFailure, List<RecipeModel>>> fetchRecipes({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      _logger.info('Fetching recipes (limit: $limit)');

      Query query = _firestore
          .collection(FirestoreConstants.recipesCollection)
          .orderBy(FirestoreConstants.recipeCreatedAt, descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      final recipes = snapshot.docs.map((doc) => RecipeModel.fromDocument(doc)).toList();

      _logger.info('Fetched ${recipes.length} recipes');
      return Right(recipes);
    } catch (e) {
      _logger.error('Failed to fetch recipes', e);
      return Left(RecipeFailure.fetchFailed());
    }
  }

  /// Get a single recipe by ID
  Future<Either<RecipeFailure, RecipeModel>> getRecipeById(String id) async {
    try {
      _logger.info('Fetching recipe: $id');

      final doc = await _firestore.collection(FirestoreConstants.recipesCollection).doc(id).get();

      if (!doc.exists) {
        _logger.warning('Recipe not found: $id');
        return Left(RecipeFailure.notFound());
      }

      final recipe = RecipeModel.fromDocument(doc);
      _logger.info('Recipe fetched successfully: $id');
      return Right(recipe);
    } catch (e) {
      _logger.error('Failed to fetch recipe: $id', e);
      return Left(RecipeFailure.fetchFailed());
    }
  }

  /// Create a new recipe
  Future<Either<RecipeFailure, String>> createRecipe(RecipeModel recipe) async {
    try {
      _logger.info('Creating recipe: ${recipe.title}');

      final docRef = await _firestore
          .collection(FirestoreConstants.recipesCollection)
          .add(recipe.toMap());

      _logger.info('Recipe created successfully: ${docRef.id}');
      return Right(docRef.id);
    } catch (e) {
      _logger.error('Failed to create recipe', e);
      return Left(RecipeFailure.createFailed());
    }
  }

  /// Update an existing recipe
  Future<Either<RecipeFailure, void>> updateRecipe(String id, RecipeModel recipe) async {
    try {
      _logger.info('Updating recipe: $id');

      await _firestore
          .collection(FirestoreConstants.recipesCollection)
          .doc(id)
          .update(recipe.toMap());

      _logger.info('Recipe updated successfully: $id');
      return const Right(null);
    } catch (e) {
      _logger.error('Failed to update recipe: $id', e);
      return Left(RecipeFailure.updateFailed());
    }
  }

  /// Delete a recipe
  Future<Either<RecipeFailure, void>> deleteRecipe(String id) async {
    try {
      _logger.info('Deleting recipe: $id');

      await _firestore.collection(FirestoreConstants.recipesCollection).doc(id).delete();

      _logger.info('Recipe deleted successfully: $id');
      return const Right(null);
    } catch (e) {
      _logger.error('Failed to delete recipe: $id', e);
      return Left(RecipeFailure.deleteFailed());
    }
  }

  /// Get recipes by author
  Future<Either<RecipeFailure, List<RecipeModel>>> getRecipesByAuthor(String authorId) async {
    try {
      _logger.info('Fetching recipes by author: $authorId');

      final snapshot = await _firestore
          .collection(FirestoreConstants.recipesCollection)
          .where(FirestoreConstants.recipeAuthorId, isEqualTo: authorId)
          .orderBy(FirestoreConstants.recipeCreatedAt, descending: true)
          .get();

      final recipes = snapshot.docs.map((doc) => RecipeModel.fromDocument(doc)).toList();

      _logger.info('Fetched ${recipes.length} recipes for author: $authorId');
      return Right(recipes);
    } catch (e) {
      _logger.error('Failed to fetch recipes by author: $authorId', e);
      return Left(RecipeFailure.fetchFailed());
    }
  }

  /// Search recipes by title
  Future<Either<RecipeFailure, List<RecipeModel>>> searchRecipes(String query) async {
    try {
      _logger.info('Searching recipes: $query');

      // Note: This is a simple implementation. For production,
      // consider using Algolia or similar for better search
      final snapshot = await _firestore
          .collection(FirestoreConstants.recipesCollection)
          .orderBy(FirestoreConstants.recipeTitle)
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .get();

      final recipes = snapshot.docs.map((doc) => RecipeModel.fromDocument(doc)).toList();

      _logger.info('Found ${recipes.length} recipes for query: $query');
      return Right(recipes);
    } catch (e) {
      _logger.error('Failed to search recipes: $query', e);
      return Left(RecipeFailure.fetchFailed());
    }
  }
}
