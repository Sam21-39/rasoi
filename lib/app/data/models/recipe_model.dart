import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  String? id;
  String title;
  String imageURL;
  String authorId;
  String authorName;
  String authorPhoto;
  String category;
  List<String> ingredients;
  List<String> instructions;
  String cookTime;
  String difficulty;
  int servings;
  int likeCount;
  DateTime? createdAt;
  Map<String, dynamic>? nutrition; // calories, protein, carbs, fat
  List<String>? allergens;
  bool isPublished;

  RecipeModel({
    this.id,
    required this.title,
    required this.imageURL,
    required this.authorId,
    required this.authorName,
    required this.authorPhoto,
    required this.category,
    required this.ingredients,
    required this.instructions,
    required this.cookTime,
    required this.difficulty,
    required this.servings,
    this.likeCount = 0,
    this.createdAt,
    this.nutrition,
    this.allergens,
    this.isPublished = true,
  });

  factory RecipeModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeModel(
      id: doc.id,
      title: data['title'] ?? '',
      imageURL: data['imageURL'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? 'Unknown',
      authorPhoto: data['authorPhoto'] ?? '',
      category: data['category'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      instructions: List<String>.from(data['instructions'] ?? []),
      cookTime: data['cookTime'] ?? '',
      difficulty: data['difficulty'] ?? '',
      servings: data['servings'] ?? 1,
      likeCount: data['likeCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      nutrition: data['nutrition'] as Map<String, dynamic>?,
      allergens: data['allergens'] != null ? List<String>.from(data['allergens']) : null,
      isPublished: data['isPublished'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageURL': imageURL,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhoto': authorPhoto,
      'category': category,
      'ingredients': ingredients,
      'instructions': instructions,
      'cookTime': cookTime,
      'difficulty': difficulty,
      'servings': servings,
      'likeCount': likeCount,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'nutrition': nutrition,
      'allergens': allergens,
      'isPublished': isPublished,
    };
  }
}
