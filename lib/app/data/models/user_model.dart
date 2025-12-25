import 'package:cloud_firestore/cloud_firestore.dart';

/// User Model
/// Represents a user profile in the Rasoi app
class UserModel {
  final String userId;
  final String email;
  final String displayName;
  final String photoUrl;
  final String bio;
  final List<String> dietaryPreferences;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int recipesCount;
  final int likesReceived;
  final int followersCount;

  const UserModel({
    required this.userId,
    required this.email,
    required this.displayName,
    this.photoUrl = '',
    this.bio = '',
    this.dietaryPreferences = const [],
    required this.createdAt,
    required this.updatedAt,
    this.recipesCount = 0,
    this.likesReceived = 0,
    this.followersCount = 0,
  });

  /// Create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson(data, doc.id);
  }

  /// Create UserModel from JSON map
  factory UserModel.fromJson(Map<String, dynamic> json, [String? id]) {
    return UserModel(
      userId: id ?? json['userId'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      bio: json['bio'] ?? '',
      dietaryPreferences: List<String>.from(json['dietaryPreferences'] ?? []),
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
      recipesCount: json['recipesCount'] ?? 0,
      likesReceived: json['likesReceived'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
    );
  }

  /// Convert UserModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
      'dietaryPreferences': dietaryPreferences,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'recipesCount': recipesCount,
      'likesReceived': likesReceived,
      'followersCount': followersCount,
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? userId,
    String? email,
    String? displayName,
    String? photoUrl,
    String? bio,
    List<String>? dietaryPreferences,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? recipesCount,
    int? likesReceived,
    int? followersCount,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      recipesCount: recipesCount ?? this.recipesCount,
      likesReceived: likesReceived ?? this.likesReceived,
      followersCount: followersCount ?? this.followersCount,
    );
  }

  /// Create empty user
  factory UserModel.empty() {
    return UserModel(
      userId: '',
      email: '',
      displayName: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Check if user is empty
  bool get isEmpty => userId.isEmpty;
  bool get isNotEmpty => userId.isNotEmpty;

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
    return 'UserModel(userId: $userId, displayName: $displayName, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}
