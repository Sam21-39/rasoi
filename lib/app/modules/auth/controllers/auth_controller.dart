import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

/// Auth Controller
/// Manages authentication state and Google Sign-In flow
class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable state
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel> currentUser = Rx<UserModel>(UserModel.empty());
  final RxBool isLoading = false.obs;
  final RxBool isNewUser = false.obs;
  final RxString errorMessage = ''.obs;

  // Getters
  bool get isLoggedIn => firebaseUser.value != null;
  String get userId => firebaseUser.value?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
  }

  /// Handle authentication state changes
  Future<void> _handleAuthChanged(User? user) async {
    if (user == null) {
      currentUser.value = UserModel.empty();
      return;
    }

    // Fetch or create user profile
    await _fetchUserProfile(user.uid);
  }

  /// Fetch user profile from Firestore
  Future<void> _fetchUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        currentUser.value = UserModel.fromFirestore(doc);
        isNewUser.value = false;
      } else {
        isNewUser.value = true;
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch user profile';
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        isLoading.value = false;
        return false;
      }

      // Obtain auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        throw Exception('Sign in failed: User is null');
      }

      // Check if user exists in Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        // Create new user profile
        final newUser = UserModel(
          userId: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
          photoUrl: user.photoURL ?? '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toJson());

        currentUser.value = newUser;
        isNewUser.value = true;
      } else {
        currentUser.value = UserModel.fromFirestore(doc);
        isNewUser.value = false;
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateUserProfile({
    String? displayName,
    String? bio,
    String? photoUrl,
    List<String>? dietaryPreferences,
  }) async {
    try {
      isLoading.value = true;

      final updates = <String, dynamic>{'updatedAt': Timestamp.now()};

      if (displayName != null) updates['displayName'] = displayName;
      if (bio != null) updates['bio'] = bio;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;
      if (dietaryPreferences != null) {
        updates['dietaryPreferences'] = dietaryPreferences;
      }

      await _firestore.collection('users').doc(userId).update(updates);

      // Update local state
      currentUser.value = currentUser.value.copyWith(
        displayName: displayName,
        bio: bio,
        photoUrl: photoUrl,
        dietaryPreferences: dietaryPreferences,
        updatedAt: DateTime.now(),
      );

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      return false;
    }
  }

  /// Save dietary preferences and navigate to main
  Future<void> saveDietaryPreferences(List<String> preferences) async {
    final success = await updateUserProfile(dietaryPreferences: preferences);

    if (success) {
      isNewUser.value = false;
      Get.offAllNamed(AppRoutes.main);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _googleSignIn.signOut();
      await _auth.signOut();
      currentUser.value = UserModel.empty();
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.welcome);
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }

  /// Delete user account
  Future<bool> deleteAccount() async {
    try {
      isLoading.value = true;

      // Delete user document from Firestore
      await _firestore.collection('users').doc(userId).delete();

      // Delete Firebase Auth account
      await firebaseUser.value?.delete();

      // Sign out from Google
      await _googleSignIn.signOut();

      currentUser.value = UserModel.empty();
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.welcome);
      return true;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }
}
