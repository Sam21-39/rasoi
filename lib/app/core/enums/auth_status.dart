/// Authentication status enumeration
enum AuthStatus { authenticated, unauthenticated, loading, emailNotVerified }

extension AuthStatusExtension on AuthStatus {
  bool get isAuthenticated => this == AuthStatus.authenticated;
  bool get isUnauthenticated => this == AuthStatus.unauthenticated;
  bool get isLoading => this == AuthStatus.loading;
  bool get isEmailNotVerified => this == AuthStatus.emailNotVerified;
}
