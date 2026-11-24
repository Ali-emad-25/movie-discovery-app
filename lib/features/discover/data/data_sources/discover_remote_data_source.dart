import 'package:movie_discovery_app/features/home/home_tab/data/models/movie_response_model.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/person_model.dart';

abstract class DiscoverRemoteDataSource {
  Future<MovieResponseModel> getMovies({
    required String endpoint,
    int page = 1,
    Map<String, dynamic>? queryParameters,
  });

  Future<MovieResponseModel> getTvShows({
    required String endpoint,
    int page = 1,
    Map<String, dynamic>? queryParameters,
  });

  Future<PersonResponseModel> getPeople({
    required String endpoint,
    int page = 1,
  });
}
