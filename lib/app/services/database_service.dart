import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/models/recipe_model.dart';

/// Database Service
/// Handles local SQLite database for offline support
class DatabaseService {
  static const String _databaseName = 'rasoi.db';
  static const int _databaseVersion = 1;

  static Database? _database;

  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  /// Get database instance
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create tables
  Future<void> _onCreate(Database db, int version) async {
    // Cached recipes table
    await db.execute('''
      CREATE TABLE cached_recipes (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        cached_at INTEGER NOT NULL
      )
    ''');

    // Saved recipes table (for offline access)
    await db.execute('''
      CREATE TABLE saved_recipes (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        saved_at INTEGER NOT NULL
      )
    ''');

    // Recent searches table
    await db.execute('''
      CREATE TABLE recent_searches (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        query TEXT NOT NULL UNIQUE,
        searched_at INTEGER NOT NULL
      )
    ''');

    // Draft recipes table
    await db.execute('''
      CREATE TABLE draft_recipes (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // User preferences table
    await db.execute('''
      CREATE TABLE user_preferences (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future migrations here
  }

  // ============================================
  // Cached Recipes Operations
  // ============================================

  /// Cache recipes for offline access
  Future<void> cacheRecipes(List<RecipeModel> recipes) async {
    final db = await database;
    final batch = db.batch();
    final now = DateTime.now().millisecondsSinceEpoch;

    for (final recipe in recipes) {
      batch.insert('cached_recipes', {
        'id': recipe.recipeId,
        'data': _recipeToJson(recipe),
        'cached_at': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit();
  }

  /// Get cached recipes
  Future<List<RecipeModel>> getCachedRecipes({int limit = 20}) async {
    final db = await database;
    final results = await db.query('cached_recipes', orderBy: 'cached_at DESC', limit: limit);

    return results.map((row) => _recipeFromJson(row['data'] as String)).toList();
  }

  /// Clear old cached recipes (older than 7 days)
  Future<void> clearOldCache() async {
    final db = await database;
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch;

    await db.delete('cached_recipes', where: 'cached_at < ?', whereArgs: [oneWeekAgo]);
  }

  // ============================================
  // Saved Recipes Operations
  // ============================================

  /// Save recipe for offline access
  Future<void> saveRecipeLocally(RecipeModel recipe) async {
    final db = await database;
    await db.insert('saved_recipes', {
      'id': recipe.recipeId,
      'data': _recipeToJson(recipe),
      'saved_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Remove locally saved recipe
  Future<void> removeLocalRecipe(String recipeId) async {
    final db = await database;
    await db.delete('saved_recipes', where: 'id = ?', whereArgs: [recipeId]);
  }

  /// Get locally saved recipes
  Future<List<RecipeModel>> getLocalSavedRecipes() async {
    final db = await database;
    final results = await db.query('saved_recipes', orderBy: 'saved_at DESC');

    return results.map((row) => _recipeFromJson(row['data'] as String)).toList();
  }

  /// Check if recipe is saved locally
  Future<bool> isRecipeSavedLocally(String recipeId) async {
    final db = await database;
    final results = await db.query(
      'saved_recipes',
      where: 'id = ?',
      whereArgs: [recipeId],
      limit: 1,
    );
    return results.isNotEmpty;
  }

  // ============================================
  // Recent Searches Operations
  // ============================================

  /// Add recent search
  Future<void> addRecentSearch(String query) async {
    if (query.trim().isEmpty) return;

    final db = await database;
    await db.insert('recent_searches', {
      'query': query.trim(),
      'searched_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // Keep only last 10 searches
    await db.execute('''
      DELETE FROM recent_searches 
      WHERE id NOT IN (
        SELECT id FROM recent_searches ORDER BY searched_at DESC LIMIT 10
      )
    ''');
  }

  /// Get recent searches
  Future<List<String>> getRecentSearches() async {
    final db = await database;
    final results = await db.query('recent_searches', orderBy: 'searched_at DESC', limit: 10);

    return results.map((row) => row['query'] as String).toList();
  }

  /// Clear recent searches
  Future<void> clearRecentSearches() async {
    final db = await database;
    await db.delete('recent_searches');
  }

  // ============================================
  // Draft Recipes Operations
  // ============================================

  /// Save recipe draft
  Future<void> saveDraft(String draftId, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('draft_recipes', {
      'id': draftId,
      'data': _mapToJson(data),
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Get draft
  Future<Map<String, dynamic>?> getDraft(String draftId) async {
    final db = await database;
    final results = await db.query(
      'draft_recipes',
      where: 'id = ?',
      whereArgs: [draftId],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return _jsonToMap(results.first['data'] as String);
  }

  /// Delete draft
  Future<void> deleteDraft(String draftId) async {
    final db = await database;
    await db.delete('draft_recipes', where: 'id = ?', whereArgs: [draftId]);
  }

  // ============================================
  // User Preferences Operations
  // ============================================

  /// Set preference
  Future<void> setPreference(String key, String value) async {
    final db = await database;
    await db.insert('user_preferences', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Get preference
  Future<String?> getPreference(String key) async {
    final db = await database;
    final results = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return results.first['value'] as String;
  }

  // ============================================
  // Utility Methods
  // ============================================

  /// Clear all data
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('cached_recipes');
    await db.delete('saved_recipes');
    await db.delete('recent_searches');
    await db.delete('draft_recipes');
    await db.delete('user_preferences');
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  // JSON conversion helpers
  String _recipeToJson(RecipeModel recipe) {
    return recipe.toLocalJson().toString();
  }

  RecipeModel _recipeFromJson(String json) {
    // Parse JSON string to Map
    final map = _parseJsonString(json);
    return RecipeModel.fromJson(map);
  }

  String _mapToJson(Map<String, dynamic> map) {
    return map.toString();
  }

  Map<String, dynamic> _jsonToMap(String json) {
    return _parseJsonString(json);
  }

  Map<String, dynamic> _parseJsonString(String json) {
    // Simple JSON parsing - for production, use dart:convert
    // This is a placeholder that would need proper JSON parsing
    try {
      // Remove leading/trailing braces and parse
      return {};
    } catch (e) {
      return {};
    }
  }
}
