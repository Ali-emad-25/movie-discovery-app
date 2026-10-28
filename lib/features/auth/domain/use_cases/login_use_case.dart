import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_result.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  const LoginUseCase(this.repository);

  Future<ApiResult<User>> continueAsGuest() => repository.continueAsGuest();

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
    return repository.login(email: email.trim(), password: password);
  }
}
