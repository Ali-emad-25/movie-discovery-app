import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/movie_response_model.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/person_model.dart';

abstract class DiscoverRepository {
  Future<ApiResult<MovieResponseModel>> getMovies({
    required String endpoint,
    int page = 1,
  });

  Future<ApiResult<MovieResponseModel>> getTvShows({
    required String endpoint,
    int page = 1,
  });

  Future<ApiResult<PersonResponseModel>> getPeople({
    required String endpoint,
    int page = 1,
  });
}
