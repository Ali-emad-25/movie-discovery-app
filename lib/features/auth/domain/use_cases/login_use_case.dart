
import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';
import 'package:movie_discovery_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<User> call({
    required String email,
    required String password,
  }) {
    return authRepository.login(
      email: email,
      password: password,
    );
  }
}
