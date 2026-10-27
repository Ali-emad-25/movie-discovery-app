import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetEmailUseCase {
  final AuthRepository authRepository;

  const SendPasswordResetEmailUseCase(this.authRepository);

  Future<ApiResult<void>> call({required String email}) {
    return authRepository.sendPasswordResetEmail(email: email);
  }
}
