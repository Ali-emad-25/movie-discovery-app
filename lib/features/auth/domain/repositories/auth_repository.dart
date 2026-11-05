import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<ApiResult<User>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<ApiResult<User>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<User>> signInWithGoogle();

  Future<ApiResult<User>> continueAsGuest();

  Future<ApiResult<void>> logout();

  Future<ApiResult<User?>> getCurrentUser();

  Future<ApiResult<void>> sendPasswordResetEmail({
    required String email,
  });
}
