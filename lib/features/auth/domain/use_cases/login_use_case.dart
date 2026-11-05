
import 'package:movie_discovery_app/core/errors/failures.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';

import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';
import 'package:movie_discovery_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<ApiResult<User>> continueAsGuest() {
    return repository.continueAsGuest();
  }

  Future<ApiResult<User>> call({
    required String email,
    required String password,
  }) async {
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim())) {
      return const ApiError(AuthErrorFailure('auth.invalid_email'));
    }

    if (password.isEmpty) {
      return const ApiError(AuthErrorFailure('auth.password_required'));
    }

    return repository.login(
      email: email.trim(),
      password: password,
    );
  }
}
