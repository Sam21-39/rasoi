import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../models/user_model.dart';
import '../../core/errors/auth_failures.dart';
import '../../core/services/logger_service.dart';
import '../../core/constants/firestore_constants.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoggerService _logger = LoggerService();

  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<UserModel?> appUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    currentUser.bindStream(_auth.authStateChanges());
    ever(currentUser, _handleAuthChanged);
  }

  Future<void> _handleAuthChanged(User? firebaseUser) async {
    if (firebaseUser != null) {
      await _fetchUserProfile(firebaseUser.uid);
    } else {
      appUser.value = null;
    }
  }

  Future<void> _fetchUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection(FirestoreConstants.usersCollection).doc(uid).get();
      if (doc.exists) {
        appUser.value = UserModel.fromDocument(doc);
      }
    } catch (e) {
      _logger.error('Error fetching user profile', e);
    }
  }

  /// Sign up with email and password
  Future<Either<AuthFailure, UserCredential>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      _logger.info('Attempting signup for email: $email');

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Create user profile in Firestore
      await _createUserProfile(
        uid: userCredential.user!.uid,
        email: email,
        displayName: displayName,
      );

      _logger.info('Signup successful for: $email');
      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      _logger.error('Signup failed', e);
      return Left(AuthFailure.fromCode(e.code));
    } catch (e) {
      _logger.error('Unexpected signup error', e);
      return const Left(
        AuthFailure(AuthFailureType.unknown, 'An unexpected error occurred during signup'),
      );
    }
  }

  /// Sign in with email and password
  Future<Either<AuthFailure, UserCredential>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Attempting signin for email: $email');

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _logger.info('Signin successful for: $email');
      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      _logger.error('Signin failed', e);
      return Left(AuthFailure.fromCode(e.code));
    } catch (e) {
      _logger.error('Unexpected signin error', e);
      return const Left(
        AuthFailure(AuthFailureType.unknown, 'An unexpected error occurred during signin'),
      );
    }
  }

  /// Send password reset email
  Future<Either<AuthFailure, void>> sendPasswordResetEmail(String email) async {
    try {
      _logger.info('Sending password reset email to: $email');

      await _auth.sendPasswordResetEmail(email: email);

      _logger.info('Password reset email sent to: $email');
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      _logger.error('Password reset failed', e);
      return Left(AuthFailure.fromCode(e.code));
    } catch (e) {
      _logger.error('Unexpected password reset error', e);
      return const Left(
        AuthFailure(AuthFailureType.unknown, 'Failed to send password reset email'),
      );
    }
  }

  /// Send email verification
  Future<Either<AuthFailure, void>> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const Left(
          AuthFailure(AuthFailureType.userNotFound, 'No user is currently signed in'),
        );
      }

      await user.sendEmailVerification();
      _logger.info('Verification email sent');
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      _logger.error('Email verification failed', e);
      return Left(AuthFailure.fromCode(e.code));
    } catch (e) {
      _logger.error('Unexpected email verification error', e);
      return const Left(AuthFailure(AuthFailureType.unknown, 'Failed to send verification email'));
    }
  }

  /// Check if email is verified
  Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  /// Create user profile in Firestore with subcollections
  Future<void> _createUserProfile({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    try {
      final batch = _firestore.batch();

      // Create user document
      final userRef = _firestore.collection(FirestoreConstants.usersCollection).doc(uid);

      final userData = UserModel(
        uid: uid,
        email: email,
        displayName: displayName,
        photoURL: '',
        bio: '',
        isEmailVerified: false,
        followerCount: 0,
        followingCount: 0,
        recipeCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        preferences: {'themeMode': 'system', 'language': 'en', 'notificationsEnabled': true},
      );

      batch.set(userRef, userData.toMap());

      // Initialize empty subcollections by creating placeholder docs
      // (Firestore doesn't create empty collections, so we'll skip this)
      // The collections will be created when first follower/following is added

      await batch.commit();

      // Fetch the created profile
      await _fetchUserProfile(uid);

      _logger.info('User profile created for: $email');
    } catch (e) {
      _logger.error('Failed to create user profile', e);
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    if (currentUser.value == null) return;

    try {
      await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(currentUser.value!.uid)
          .update(user.toMap());

      await _fetchUserProfile(currentUser.value!.uid);
      _logger.info('User profile updated');
    } catch (e) {
      _logger.error('Failed to update user profile', e);
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _logger.info('User signed out');
    } catch (e) {
      _logger.error('Sign out failed', e);
      rethrow;
    }
  }

  /// Check if user is logged in
  bool get isLoggedIn => currentUser.value != null;

  /// Check if user has completed profile
  bool get hasCompletedProfile => appUser.value != null;
}
