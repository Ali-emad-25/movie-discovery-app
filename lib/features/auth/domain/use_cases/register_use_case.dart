
import 'package:movie_discovery_app/core/errors/failures.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';
import 'package:movie_discovery_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  Future<ApiResult<User>> call({
    required String name,
    required String email,
    required String password,
  }) {
    if (name.trim().length < 2) {
      return Future.value(
        const ApiError(AuthErrorFailure('auth.name_invalid')),
      );
    }

    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
        .hasMatch(email.trim())) {
      return Future.value(
        const ApiError(AuthErrorFailure('auth.invalid_email')),
      );
    }

    if (password.length < 6) {
      return Future.value(
        const ApiError(AuthErrorFailure('auth.weak_password')),
      );
    }

    return authRepository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}
