import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:movie_discovery_app/core/errors/failures.dart';
import 'package:movie_discovery_app/core/errors/firebase_auth_error_handler.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';
import 'package:movie_discovery_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('Failed to create user account.');
    }

    return User(
      id: user.uid,
      email: user.email ?? email.trim(),
      displayName: user.displayName ?? name.trim(),
      isGuest: user.isAnonymous,
    );
  }

  @override
  Future<User> login({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<User> continueAsGuest() {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<User?> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email: email);
      return const ApiSuccess(null);
    } on fb.FirebaseAuthException catch (e) {
      return ApiError(FirebaseAuthErrorHandler.handle(e));
    } catch (e) {
      return ApiError(UnknownFailure(e.toString()));
    }
  }
}
