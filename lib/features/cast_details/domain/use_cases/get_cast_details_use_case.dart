import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/cast_details/domain/entities/cast_details.dart';
import 'package:movie_discovery_app/features/cast_details/domain/repositories/cast_details_repository.dart';

class GetCastDetailsUseCase {
  final CastDetailsRepository repository;

  const GetCastDetailsUseCase(this.repository);

  Future<ApiResult<CastDetails>> call(
    int personId, {
    required String language,
  }) => repository.getCastDetails(personId, language: language);
}
