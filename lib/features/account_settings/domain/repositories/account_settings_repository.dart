import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/account_settings/domain/entities/account_profile.dart';

abstract class AccountSettingsRepository {
  Future<ApiResult<AccountProfile?>> getProfile(String userId);
  Future<ApiResult<AccountProfile>> saveProfile(AccountProfile profile);
  Future<ApiResult<void>> deleteProfile(String userId);
}
