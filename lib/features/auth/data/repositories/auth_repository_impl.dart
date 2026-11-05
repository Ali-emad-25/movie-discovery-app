
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

    return _mapUser(user);
  }

  @override
  Future<ApiResult<User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await remoteDataSource.login(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        return const ApiError(AuthErrorFailure('auth.login_error'));
      }

      return ApiSuccess(_mapUser(user));
    } on fb.FirebaseAuthException catch (e) {
      return ApiError(FirebaseAuthErrorHandler.handle(e));
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<User>> continueAsGuest() async {
    final result = await logout();

    return switch (result) {
      ApiSuccess() => const ApiSuccess(User.guest()),
      ApiError(failure: final failure) => ApiError(failure),
    };
  }

  @override
  Future<ApiResult<void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const ApiSuccess(null);
    } on fb.FirebaseAuthException catch (e) {
      return ApiError(FirebaseAuthErrorHandler.handle(e));
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<User?>> getCurrentUser() async {
    try {
      final user = remoteDataSource.getCurrentUser();
      return ApiSuccess(user == null ? null : _mapUser(user));
    } on fb.FirebaseAuthException catch (e) {
      return ApiError(FirebaseAuthErrorHandler.handle(e));
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }

  User _mapUser(fb.User user) {
    return User(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isGuest: user.isAnonymous,
    );
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
