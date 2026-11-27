import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<UserCredential> login({
    required String email,
    required String password,
  });

  Future<User?> getCurrentUser();

  Future<void> logout();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> deleteAccount({required String currentPassword});

  Future<UserCredential> continueAsGuest();

  Future<UserCredential> signInWithGoogle();
}
