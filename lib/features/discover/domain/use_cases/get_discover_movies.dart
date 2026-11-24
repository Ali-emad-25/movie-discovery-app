import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/discover/domain/repositories/discover_repository.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/movie_response_model.dart';

class GetDiscoverMovies {
  final DiscoverRepository repository;

  const GetDiscoverMovies(this.repository);

  Future<ApiResult<MovieResponseModel>> call({
    required String endpoint,
    int page = 1,
    Map<String, dynamic>? queryParameters,
  }) {
    return repository.getMovies(
      endpoint: endpoint,
      page: page,
      queryParameters: queryParameters,
    );
  }
}
