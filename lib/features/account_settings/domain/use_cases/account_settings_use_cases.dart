import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/account_settings/domain/entities/account_profile.dart';
import 'package:movie_discovery_app/features/account_settings/domain/repositories/account_settings_repository.dart';
import 'package:movie_discovery_app/features/auth/domain/repositories/auth_repository.dart';

class GetLocalAccountProfileUseCase {
  final AccountSettingsRepository repository;

  const GetLocalAccountProfileUseCase(this.repository);

  Future<ApiResult<AccountProfile?>> call({required String userId}) =>
      repository.getProfile(userId);
}

class SaveLocalAccountProfileUseCase {
  final AccountSettingsRepository repository;

  const SaveLocalAccountProfileUseCase(this.repository);

  Future<ApiResult<AccountProfile>> call({required AccountProfile profile}) =>
      repository.saveProfile(profile);
}

class DeleteLocalAccountProfileUseCase {
  final AccountSettingsRepository repository;

  const DeleteLocalAccountProfileUseCase(this.repository);

  Future<ApiResult<void>> call({required String userId}) =>
      repository.deleteProfile(userId);
}

class ChangeAccountPasswordUseCase {
  final AuthRepository repository;

  const ChangeAccountPasswordUseCase(this.repository);

  Future<ApiResult<void>> call({
    required String currentPassword,
    required String newPassword,
  }) => repository.changePassword(
    currentPassword: currentPassword,
    newPassword: newPassword,
  );
}

class DeleteAccountUseCase {
  final AuthRepository repository;

  const DeleteAccountUseCase(this.repository);

  Future<ApiResult<void>> call({required String currentPassword}) =>
      repository.deleteAccount(currentPassword: currentPassword);
}
