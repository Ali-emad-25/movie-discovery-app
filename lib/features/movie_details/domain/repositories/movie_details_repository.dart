import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_details.dart';

abstract class MovieDetailsRepository {
  Future<ApiResult<MovieDetails>> getMovieDetails(int movieId);
}
