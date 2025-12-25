import 'package:cloud_firestore/cloud_firestore.dart';
import 'ingredient_model.dart';
import 'instruction_model.dart';

/// Recipe Model
/// Represents a recipe in the Rasoi app
class RecipeModel {
  final String recipeId;
  final String authorId;
  final String authorName;
  final String authorPhotoUrl;
  final String title;
  final String description;
  final String category;
  final List<String> dietaryTypes;
  final int cookingTime; // in minutes
  final String difficulty;
  final int servings;
  final String imageUrl;
  final List<IngredientModel> ingredients;
  final List<InstructionModel> instructions;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final int sharesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Local state (not stored in Firestore)
  final bool isLiked;
  final bool isSaved;

  const RecipeModel({
    required this.recipeId,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl = '',
    required this.title,
    this.description = '',
    required this.category,
    this.dietaryTypes = const [],
    required this.cookingTime,
    required this.difficulty,
    required this.servings,
    required this.imageUrl,
    this.ingredients = const [],
    this.instructions = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.viewsCount = 0,
    this.sharesCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isLiked = false,
    this.isSaved = false,
  });

  /// Create RecipeModel from Firestore document
  factory RecipeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeModel.fromJson(data, doc.id);
  }

  /// Create RecipeModel from JSON map
  factory RecipeModel.fromJson(Map<String, dynamic> json, [String? id]) {
    return RecipeModel(
      recipeId: id ?? json['recipeId'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      authorPhotoUrl: json['authorPhotoUrl'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      dietaryTypes: List<String>.from(json['dietaryTypes'] ?? []),
      cookingTime: json['cookingTime'] ?? 0,
      difficulty: json['difficulty'] ?? 'Easy',
      servings: json['servings'] ?? 1,
      imageUrl: json['imageUrl'] ?? '',
      ingredients:
          (json['ingredients'] as List<dynamic>?)
              ?.map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      instructions:
          (json['instructions'] as List<dynamic>?)
              ?.map((e) => InstructionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      viewsCount: json['viewsCount'] ?? 0,
      sharesCount: json['sharesCount'] ?? 0,
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
      isLiked: json['isLiked'] ?? false,
      isSaved: json['isSaved'] ?? false,
    );
  }

  /// Convert RecipeModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhotoUrl': authorPhotoUrl,
      'title': title,
      'description': description,
      'category': category,
      'dietaryTypes': dietaryTypes,
      'cookingTime': cookingTime,
      'difficulty': difficulty,
      'servings': servings,
      'imageUrl': imageUrl,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'instructions': instructions.map((e) => e.toJson()).toList(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'viewsCount': viewsCount,
      'sharesCount': sharesCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Convert to JSON for local storage
  Map<String, dynamic> toLocalJson() {
    final json = toJson();
    json['createdAt'] = createdAt.toIso8601String();
    json['updatedAt'] = updatedAt.toIso8601String();
    json['isLiked'] = isLiked;
    json['isSaved'] = isSaved;
    return json;
  }

  /// Create a copy with updated fields
  RecipeModel copyWith({
    String? recipeId,
    String? authorId,
    String? authorName,
    String? authorPhotoUrl,
    String? title,
    String? description,
    String? category,
    List<String>? dietaryTypes,
    int? cookingTime,
    String? difficulty,
    int? servings,
    String? imageUrl,
    List<IngredientModel>? ingredients,
    List<InstructionModel>? instructions,
    int? likesCount,
    int? commentsCount,
    int? viewsCount,
    int? sharesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLiked,
    bool? isSaved,
  }) {
    return RecipeModel(
      recipeId: recipeId ?? this.recipeId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorPhotoUrl: authorPhotoUrl ?? this.authorPhotoUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dietaryTypes: dietaryTypes ?? this.dietaryTypes,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
      servings: servings ?? this.servings,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      viewsCount: viewsCount ?? this.viewsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  /// Create empty recipe
  factory RecipeModel.empty() {
    return RecipeModel(
      recipeId: '',
      authorId: '',
      authorName: '',
      title: '',
      category: '',
      cookingTime: 0,
      difficulty: 'Easy',
      servings: 1,
      imageUrl: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // ============================================
  // Computed Properties
  // ============================================

  /// Check if recipe is empty
  bool get isEmpty => recipeId.isEmpty;
  bool get isNotEmpty => recipeId.isNotEmpty;

  /// Get formatted cooking time
  String get formattedCookingTime {
    if (cookingTime < 60) {
      return '$cookingTime min';
    } else {
      final hours = cookingTime ~/ 60;
      final minutes = cookingTime % 60;
      if (minutes == 0) {
        return '$hours hr';
      }
      return '$hours hr $minutes min';
    }
  }

  /// Check if recipe is vegetarian
  bool get isVegetarian => dietaryTypes.contains('Vegetarian');

  /// Check if recipe is vegan
  bool get isVegan => dietaryTypes.contains('Vegan');

  /// Get dietary type icon
  String get dietaryIcon {
    if (dietaryTypes.contains('Vegetarian')) return '🟢';
    if (dietaryTypes.contains('Vegan')) return '🌱';
    if (dietaryTypes.contains('Eggetarian')) return '🟡';
    return '🔴';
  }

  /// Parse Firestore Timestamp to DateTime
  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is DateTime) {
      return timestamp;
    } else if (timestamp is String) {
      return DateTime.tryParse(timestamp) ?? DateTime.now();
    }
    return DateTime.now();
  }

  @override
  String toString() {
    return 'RecipeModel(recipeId: $recipeId, title: $title, author: $authorName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecipeModel && other.recipeId == recipeId;
  }

  @override
  int get hashCode => recipeId.hashCode;
}
