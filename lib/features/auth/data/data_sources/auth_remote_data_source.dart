import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  });
}
