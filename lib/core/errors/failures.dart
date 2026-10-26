sealed class Failure {
  final String message;
  const Failure(this.message);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred. Please try again.']);
}

final class AuthErrorFailure extends Failure {
  const AuthErrorFailure(super.message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Please check your internet connection.']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred. Please try again.']);
}
