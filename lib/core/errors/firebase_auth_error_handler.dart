import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_discovery_app/core/errors/failures.dart';

class FirebaseAuthErrorHandler {
  static Failure handle(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return const AuthErrorFailure('No user found with this email address.');
      case 'invalid-email':
        return const AuthErrorFailure('The provided email address is not valid.');
      case 'user-disabled':
        return const AuthErrorFailure('This user account has been disabled.');
      case 'wrong-password':
        return const AuthErrorFailure('Incorrect password. Please try again.');
      case 'email-already-in-use':
        return const AuthErrorFailure('An account already exists for this email.');
      case 'operation-not-allowed':
        return const AuthErrorFailure('Email/password accounts are not enabled.');
      case 'weak-password':
        return const AuthErrorFailure('The password provided is too weak.');
      case 'network-request-failed':
        return const NetworkFailure('Network connection failed. Please check your internet.');
      case 'too-many-requests':
        return const AuthErrorFailure('Too many requests. Please try again later.');
      default:
        return AuthErrorFailure(
          exception.message ?? 'An authentication error occurred. Please try again.',
        );
    }
  }
}
