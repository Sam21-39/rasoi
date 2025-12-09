import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class UserService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = Get.find<AuthService>();

  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      }
    } catch (e) {
      print('Error getting user profile: $e');
    }
    return null;
  }

  // Check if current user follows target user
  Future<bool> isFollowing(String targetUid) async {
    final currentUid = _authService.currentUser.value?.uid;
    if (currentUid == null) return false;

    final doc = await _firestore
        .collection('users')
        .doc(currentUid)
        .collection('following')
        .doc(targetUid)
        .get();

    return doc.exists;
  }

  Future<void> followUser(String targetUid) async {
    final currentUid = _authService.currentUser.value?.uid;
    if (currentUid == null) return;

    // Batch write for atomicity
    WriteBatch batch = _firestore.batch();

    // 1. Add to current user's 'following' subcollection
    DocumentReference followingRef = _firestore
        .collection('users')
        .doc(currentUid)
        .collection('following')
        .doc(targetUid);
    batch.set(followingRef, {'timestamp': FieldValue.serverTimestamp()});

    // 2. Add to target user's 'followers' subcollection
    DocumentReference followerRef = _firestore
        .collection('users')
        .doc(targetUid)
        .collection('followers')
        .doc(currentUid);
    batch.set(followerRef, {'timestamp': FieldValue.serverTimestamp()});

    // 3. Increment counters (Using Firestore increment)
    DocumentReference currentUserRef = _firestore.collection('users').doc(currentUid);
    batch.update(currentUserRef, {'followingCount': FieldValue.increment(1)});

    DocumentReference targetUserRef = _firestore.collection('users').doc(targetUid);
    batch.update(targetUserRef, {'followerCount': FieldValue.increment(1)});

    await batch.commit();
  }

  Future<void> unfollowUser(String targetUid) async {
    final currentUid = _authService.currentUser.value?.uid;
    if (currentUid == null) return;

    WriteBatch batch = _firestore.batch();

    // 1. Remove from following
    DocumentReference followingRef = _firestore
        .collection('users')
        .doc(currentUid)
        .collection('following')
        .doc(targetUid);
    batch.delete(followingRef);

    // 2. Remove from followers
    DocumentReference followerRef = _firestore
        .collection('users')
        .doc(targetUid)
        .collection('followers')
        .doc(currentUid);
    batch.delete(followerRef);

    // 3. Decrement counters
    DocumentReference currentUserRef = _firestore.collection('users').doc(currentUid);
    batch.update(currentUserRef, {'followingCount': FieldValue.increment(-1)});

    DocumentReference targetUserRef = _firestore.collection('users').doc(targetUid);
    batch.update(targetUserRef, {'followerCount': FieldValue.increment(-1)});

    await batch.commit();
  }
}
