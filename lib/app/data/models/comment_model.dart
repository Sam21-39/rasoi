import 'package:cloud_firestore/cloud_firestore.dart';

/// Comment Model
/// Represents a comment on a recipe
class CommentModel {
  final String commentId;
  final String recipeId;
  final String userId;
  final String userName;
  final String userPhotoUrl;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CommentModel({
    required this.commentId,
    required this.recipeId,
    required this.userId,
    required this.userName,
    this.userPhotoUrl = '',
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create CommentModel from Firestore document
  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel.fromJson(data, doc.id);
  }

  /// Create CommentModel from JSON map
  factory CommentModel.fromJson(Map<String, dynamic> json, [String? id]) {
    return CommentModel(
      commentId: id ?? json['commentId'] ?? '',
      recipeId: json['recipeId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userPhotoUrl: json['userPhotoUrl'] ?? '',
      text: json['text'] ?? '',
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  /// Convert CommentModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'recipeId': recipeId,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy with updated fields
  CommentModel copyWith({
    String? commentId,
    String? recipeId,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      recipeId: recipeId ?? this.recipeId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if comment can be edited (within 5 minutes)
  bool get canEdit {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inMinutes < 5;
  }

  /// Check if comment is from current user
  bool isOwnComment(String currentUserId) => userId == currentUserId;

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
    return 'CommentModel(commentId: $commentId, userName: $userName, text: ${text.substring(0, text.length.clamp(0, 30))})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CommentModel && other.commentId == commentId;
  }

  @override
  int get hashCode => commentId.hashCode;
}
