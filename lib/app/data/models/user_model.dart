import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? displayName;
  String? photoURL;
  String? bio;
  bool? isEmailVerified;
  int? followerCount;
  int? followingCount;
  int? recipeCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  Map<String, dynamic>? preferences;

  UserModel({
    this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.bio,
    this.isEmailVerified,
    this.followerCount,
    this.followingCount,
    this.recipeCount,
    this.createdAt,
    this.updatedAt,
    this.preferences,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      bio: data['bio'],
      isEmailVerified: data['isEmailVerified'] ?? false,
      followerCount: data['followerCount'] ?? 0,
      followingCount: data['followingCount'] ?? 0,
      recipeCount: data['recipeCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      preferences: data['preferences'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'bio': bio,
      'isEmailVerified': isEmailVerified ?? false,
      'followerCount': followerCount ?? 0,
      'followingCount': followingCount ?? 0,
      'recipeCount': recipeCount ?? 0,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'preferences': preferences ?? {},
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? bio,
    bool? isEmailVerified,
    int? followerCount,
    int? followingCount,
    int? recipeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      bio: bio ?? this.bio,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      recipeCount: recipeCount ?? this.recipeCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferences: preferences ?? this.preferences,
    );
  }
}
