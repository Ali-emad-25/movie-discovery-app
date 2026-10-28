import '../../../../core/network/api_result.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository repository;
  const GetProfileUseCase(this.repository);

  Future<ApiResult<User>> call() async {
    final result = await repository.getCurrentUser();
    return switch (result) {
      ApiSuccess(data: final user) => ApiSuccess(user ?? const User.guest()),
      ApiError(failure: final failure) => ApiError(failure),
    };
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  const LogoutUseCase(this.repository);

  Future<ApiResult<void>> call() => repository.logout();
}
