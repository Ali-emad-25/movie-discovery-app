import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_discovery_app/core/errors/firebase_auth_error_handler.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';

import 'package:movie_discovery_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';
import 'package:movie_discovery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movie_discovery_app/core/errors/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await remoteDataSource.register(
        name: name.trim(),
        email: email.trim(),
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        return const ApiError(AuthErrorFailure('auth.register_error'));
      }

      return ApiSuccess(_mapUser(user));
    } on fb.FirebaseAuthException catch (e) {
      return ApiError(FirebaseAuthErrorHandler.handle(e));
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await remoteDataSource.login(
        email: email.trim(),
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
    try {
      final credential = await remoteDataSource.continueAsGuest();

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        return const ApiError(AuthErrorFailure('auth.login_error'));
      }

      return ApiSuccess(_mapUser(firebaseUser));
    } on fb.FirebaseAuthException catch (e) {
      return ApiError(FirebaseAuthErrorHandler.handle(e));
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
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
  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const ApiSuccess(null);
    } on fb.FirebaseAuthException catch (e) {
      return ApiError(FirebaseAuthErrorHandler.handle(e));
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<void>> deleteAccount({
    required String currentPassword,
  }) async {
    try {
      await remoteDataSource.deleteAccount(currentPassword: currentPassword);
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
      final user = await remoteDataSource.getCurrentUser();

      if (user == null) {
        return const ApiSuccess(null);
      }

      return ApiSuccess(_mapUser(user));
    } on fb.FirebaseAuthException catch (e) {
      return ApiError(FirebaseAuthErrorHandler.handle(e));
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email: email.trim());

      return const ApiSuccess(null);
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
      displayName: user.displayName ?? '',
      photoUrl: user.photoURL,
      isGuest: user.isAnonymous,
    );
  }

  @override
  Future<ApiResult<User>> signInWithGoogle() async {
    try {
      final credential = await remoteDataSource.signInWithGoogle();

      final user = credential.user;

      if (user == null) {
        return const ApiError(AuthErrorFailure('auth.login_error'));
      }

      return ApiSuccess(_mapUser(user));
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return const ApiError(GoogleSignInCancelledFailure());
      }

      return const ApiError(UnknownFailure());
    } on fb.FirebaseAuthException catch (e) {
      return ApiError(FirebaseAuthErrorHandler.handle(e));
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }
}
