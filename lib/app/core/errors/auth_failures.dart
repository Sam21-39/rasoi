import 'failures.dart';

/// Authentication failure types
enum AuthFailureType {
  invalidEmail,
  weakPassword,
  emailAlreadyInUse,
  userNotFound,
  wrongPassword,
  networkError,
  emailNotVerified,
  tooManyRequests,
  userDisabled,
  operationNotAllowed,
  invalidCredential,
  unknown,
}

/// Authentication-specific failures
class AuthFailure extends Failure {
  final AuthFailureType type;

  const AuthFailure(this.type, String message) : super(message);

  factory AuthFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const AuthFailure(AuthFailureType.invalidEmail, 'The email address is not valid.');
      case 'weak-password':
        return const AuthFailure(AuthFailureType.weakPassword, 'The password is too weak.');
      case 'email-already-in-use':
        return const AuthFailure(
          AuthFailureType.emailAlreadyInUse,
          'An account already exists with this email.',
        );
      case 'user-not-found':
        return const AuthFailure(AuthFailureType.userNotFound, 'No account found with this email.');
      case 'wrong-password':
        return const AuthFailure(
          AuthFailureType.wrongPassword,
          'Incorrect password. Please try again.',
        );
      case 'network-request-failed':
        return const AuthFailure(
          AuthFailureType.networkError,
          'Network error. Please check your connection.',
        );
      case 'too-many-requests':
        return const AuthFailure(
          AuthFailureType.tooManyRequests,
          'Too many attempts. Please try again later.',
        );
      case 'user-disabled':
        return const AuthFailure(AuthFailureType.userDisabled, 'This account has been disabled.');
      case 'operation-not-allowed':
        return const AuthFailure(
          AuthFailureType.operationNotAllowed,
          'This operation is not allowed.',
        );
      case 'invalid-credential':
        return const AuthFailure(
          AuthFailureType.invalidCredential,
          'The credentials provided are invalid.',
        );
      default:
        return const AuthFailure(
          AuthFailureType.unknown,
          'An unknown error occurred. Please try again.',
        );
    }
  }
}
