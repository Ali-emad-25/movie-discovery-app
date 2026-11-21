import 'package:movie_discovery_app/features/home/home_tab/data/models/movie_response_model.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/person_model.dart';

abstract class DiscoverRemoteDataSource {
  Future<MovieResponseModel> getMovies({
    required String endpoint,
    int page = 1,
  });

  Future<MovieResponseModel> getTvShows({
    required String endpoint,
    int page = 1,
  });

  Future<PersonResponseModel> getPeople({
    required String endpoint,
    int page = 1,
  });
}
