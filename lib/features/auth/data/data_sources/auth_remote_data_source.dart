import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<UserCredential> login({
    required String email,
    required String password,
  });

  User? getCurrentUser();

  Future<void> logout();
}
