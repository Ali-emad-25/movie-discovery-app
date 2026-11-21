import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/cast_details/domain/entities/cast_details.dart';

abstract class CastDetailsRepository {
  Future<ApiResult<CastDetails>> getCastDetails(
    int personId, {
    required String language,
  });
}
