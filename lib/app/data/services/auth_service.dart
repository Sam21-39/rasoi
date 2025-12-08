import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        appUser.value = UserModel.fromDocument(doc);
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String, int?) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function(String) onCodeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> signInWithCredential(PhoneAuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }

  Future<void> createUserProfile(UserModel user) async {
    if (currentUser.value == null) return;
    await _firestore
        .collection('users')
        .doc(currentUser.value!.uid)
        .set(user.toMap(), SetOptions(merge: true));

    // Refresh local user data
    await _fetchUserProfile(currentUser.value!.uid);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  bool get isLoggedIn => currentUser.value != null;
}
