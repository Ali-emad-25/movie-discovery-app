import 'package:movie_discovery_app/core/network/api_endpoint.dart';
import 'package:movie_discovery_app/core/network/api_manager.dart';
import 'package:movie_discovery_app/features/movie_details/data/models/movie_details_model.dart';

abstract class MovieDetailsRemoteDataSource {
  Future<MovieDetailsModel> getMovieDetails(int movieId);
}

class MovieDetailsRemoteDataSourceImpl implements MovieDetailsRemoteDataSource {
  final ApiManager _apiManager;

  const MovieDetailsRemoteDataSourceImpl(this._apiManager);

  @override
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    final response = await _apiManager.get(
      '${ApiEndpoints.movieDetails}$movieId',
      queryParameters: {
        'append_to_response': 'credits,similar,videos',
      },
    );

    return MovieDetailsModel.fromJson(response.data as Map<String, dynamic>);
  }
}
