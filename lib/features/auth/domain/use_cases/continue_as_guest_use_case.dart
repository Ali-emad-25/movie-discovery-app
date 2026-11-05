import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/auth/domain/entities/user.dart';
import 'package:movie_discovery_app/features/auth/domain/repositories/auth_repository.dart';

class ContinueAsGuestUseCase {
  final AuthRepository repository;

  ContinueAsGuestUseCase(this.repository);

  Future<ApiResult<User>> call() {
    return repository.continueAsGuest();
  }
}