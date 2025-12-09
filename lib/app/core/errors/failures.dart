/// Base class for all failures in the application
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred']) : super(message);
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) : super(message);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

/// Unknown/Unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([String message = 'An unexpected error occurred']) : super(message);
}
