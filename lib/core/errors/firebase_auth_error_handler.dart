import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_discovery_app/core/errors/failures.dart';

class FirebaseAuthErrorHandler {
  static Failure handle(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return const AuthErrorFailure('auth.user_not_found');

      case 'invalid-email':
        return const AuthErrorFailure('auth.invalid_email');

      case 'user-disabled':
        return const AuthErrorFailure('auth.user_disabled');

      case 'wrong-password':
        return const AuthErrorFailure('auth.wrong_password');

      case 'invalid-credential':
        return const AuthErrorFailure('auth.invalid_credential');

      case 'email-already-in-use':
        return const AuthErrorFailure('auth.email_already_in_use');

      case 'operation-not-allowed':
        return const AuthErrorFailure('auth.operation_not_allowed');

      case 'weak-password':
        return const AuthErrorFailure('auth.weak_password');

      case 'network-request-failed':
        return const NetworkFailure('errors.network_error');

      case 'too-many-requests':
        return const AuthErrorFailure('auth.too_many_requests');

      case 'password-sign-in-required':
        return const AuthErrorFailure(
          'account_settings.password_provider_required',
        );

      default:
        return const AuthErrorFailure('auth.login_error');
    }
  }
}
