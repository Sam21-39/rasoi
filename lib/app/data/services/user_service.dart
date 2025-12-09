import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../models/user_model.dart';
import '../../core/errors/failures.dart';
import '../../core/services/logger_service.dart';
import '../../core/constants/firestore_constants.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoggerService _logger = LoggerService();

  /// Get user profile by ID
  Future<Either<Failure, UserModel>> getUserProfile(String uid) async {
    try {
      _logger.info('Fetching user profile: $uid');

      final doc = await _firestore.collection(FirestoreConstants.usersCollection).doc(uid).get();

      if (!doc.exists) {
        _logger.warning('User not found: $uid');
        return const Left(CacheFailure('User not found'));
      }

      final user = UserModel.fromDocument(doc);
      _logger.info('User profile fetched successfully: $uid');
      return Right(user);
    } catch (e) {
      _logger.error('Failed to fetch user profile: $uid', e);
      return const Left(ServerFailure('Failed to fetch user profile'));
    }
  }

  /// Update user profile
  Future<Either<Failure, void>> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    try {
      _logger.info('Updating user profile: $uid');

      // Add updatedAt timestamp
      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection(FirestoreConstants.usersCollection).doc(uid).update(updates);

      _logger.info('User profile updated successfully: $uid');
      return const Right(null);
    } catch (e) {
      _logger.error('Failed to update user profile: $uid', e);
      return const Left(ServerFailure('Failed to update user profile'));
    }
  }

  /// Follow a user
  Future<Either<Failure, void>> followUser(String currentUserId, String targetUserId) async {
    try {
      _logger.info('User $currentUserId following $targetUserId');

      final batch = _firestore.batch();

      // Add to current user's following
      final followingRef = _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(currentUserId)
          .collection(FirestoreConstants.followingSubcollection)
          .doc(targetUserId);
      batch.set(followingRef, {'timestamp': FieldValue.serverTimestamp()});

      // Add to target user's followers
      final followerRef = _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(targetUserId)
          .collection(FirestoreConstants.followersSubcollection)
          .doc(currentUserId);
      batch.set(followerRef, {'timestamp': FieldValue.serverTimestamp()});

      // Update counts
      final currentUserRef = _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(currentUserId);
      batch.update(currentUserRef, {
        FirestoreConstants.userFollowingCount: FieldValue.increment(1),
      });

      final targetUserRef = _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(targetUserId);
      batch.update(targetUserRef, {FirestoreConstants.userFollowerCount: FieldValue.increment(1)});

      await batch.commit();
      _logger.info('Follow successful: $currentUserId -> $targetUserId');
      return const Right(null);
    } catch (e) {
      _logger.error('Failed to follow user', e);
      return const Left(ServerFailure('Failed to follow user'));
    }
  }

  /// Unfollow a user
  Future<Either<Failure, void>> unfollowUser(String currentUserId, String targetUserId) async {
    try {
      _logger.info('User $currentUserId unfollowing $targetUserId');

      final batch = _firestore.batch();

      // Remove from current user's following
      final followingRef = _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(currentUserId)
          .collection(FirestoreConstants.followingSubcollection)
          .doc(targetUserId);
      batch.delete(followingRef);

      // Remove from target user's followers
      final followerRef = _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(targetUserId)
          .collection(FirestoreConstants.followersSubcollection)
          .doc(currentUserId);
      batch.delete(followerRef);

      // Update counts
      final currentUserRef = _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(currentUserId);
      batch.update(currentUserRef, {
        FirestoreConstants.userFollowingCount: FieldValue.increment(-1),
      });

      final targetUserRef = _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(targetUserId);
      batch.update(targetUserRef, {FirestoreConstants.userFollowerCount: FieldValue.increment(-1)});

      await batch.commit();
      _logger.info('Unfollow successful: $currentUserId -> $targetUserId');
      return const Right(null);
    } catch (e) {
      _logger.error('Failed to unfollow user', e);
      return const Left(ServerFailure('Failed to unfollow user'));
    }
  }

  /// Check if user is following another user
  Future<Either<Failure, bool>> isFollowing(String currentUserId, String targetUserId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(currentUserId)
          .collection(FirestoreConstants.followingSubcollection)
          .doc(targetUserId)
          .get();

      return Right(doc.exists);
    } catch (e) {
      _logger.error('Failed to check following status', e);
      return const Left(ServerFailure('Failed to check following status'));
    }
  }

  /// Search users by display name
  Future<Either<Failure, List<UserModel>>> searchUsers(String query) async {
    try {
      _logger.info('Searching users: $query');

      final snapshot = await _firestore
          .collection(FirestoreConstants.usersCollection)
          .orderBy(FirestoreConstants.userDisplayName)
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .limit(20)
          .get();

      final users = snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();

      _logger.info('Found ${users.length} users for query: $query');
      return Right(users);
    } catch (e) {
      _logger.error('Failed to search users: $query', e);
      return const Left(ServerFailure('Failed to search users'));
    }
  }
}
