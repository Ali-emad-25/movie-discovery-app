import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_details.dart';
import 'package:movie_discovery_app/features/movie_details/domain/repositories/movie_details_repository.dart';

class GetMovieDetailsUseCase {
  final MovieDetailsRepository repository;

  const GetMovieDetailsUseCase(this.repository);

  Future<ApiResult<MovieDetails>> call(int movieId) {
    return repository.getMovieDetails(movieId);
  }
}

