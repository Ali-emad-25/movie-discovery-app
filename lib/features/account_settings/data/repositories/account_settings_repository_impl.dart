import 'package:movie_discovery_app/core/errors/failures.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/account_settings/data/data_sources/account_settings_local_data_source.dart';
import 'package:movie_discovery_app/features/account_settings/data/models/account_profile_model.dart';
import 'package:movie_discovery_app/features/account_settings/domain/entities/account_profile.dart';
import 'package:movie_discovery_app/features/account_settings/domain/repositories/account_settings_repository.dart';

class AccountSettingsRepositoryImpl implements AccountSettingsRepository {
  final AccountSettingsLocalDataSource localDataSource;

  const AccountSettingsRepositoryImpl(this.localDataSource);

  @override
  Future<ApiResult<AccountProfile?>> getProfile(String userId) async {
    try {
      return ApiSuccess(await localDataSource.getProfile(userId));
    } catch (_) {
      return const ApiError(DatabaseFailure());
    }
  }

  @override
  Future<ApiResult<AccountProfile>> saveProfile(AccountProfile profile) async {
    try {
      final model = AccountProfileModel(
        userId: profile.userId,
        displayName: profile.displayName,
        email: profile.email,
        photoUrl: profile.photoUrl,
      );
      await localDataSource.saveProfile(model);
      return ApiSuccess(model);
    } catch (_) {
      return const ApiError(DatabaseFailure());
    }
  }

  @override
  Future<ApiResult<void>> deleteProfile(String userId) async {
    try {
      await localDataSource.deleteProfile(userId);
      return const ApiSuccess(null);
    } catch (_) {
      return const ApiError(DatabaseFailure());
    }
  }
}
