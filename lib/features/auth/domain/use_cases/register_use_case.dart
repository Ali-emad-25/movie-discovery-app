import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';
import 'package:movie_discovery_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  Future<User> call({
    required String name,
    required String email,
    required String password,
  }) {
    return authRepository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}
