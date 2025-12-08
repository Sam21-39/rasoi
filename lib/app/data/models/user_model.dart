import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? phoneNumber;
  String? displayName;
  String? photoURL;
  String? bio;
  int? followerCount;
  int? followingCount;
  int? recipeCount;
  DateTime? createdAt;

  UserModel({
    this.uid,
    this.phoneNumber,
    this.displayName,
    this.photoURL,
    this.bio,
    this.followerCount,
    this.followingCount,
    this.recipeCount,
    this.createdAt,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      phoneNumber: data['phoneNumber'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      bio: data['bio'],
      followerCount: data['followerCount'] ?? 0,
      followingCount: data['followingCount'] ?? 0,
      recipeCount: data['recipeCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoURL': photoURL,
      'bio': bio,
      'followerCount': followerCount ?? 0,
      'followingCount': followingCount ?? 0,
      'recipeCount': recipeCount ?? 0,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
