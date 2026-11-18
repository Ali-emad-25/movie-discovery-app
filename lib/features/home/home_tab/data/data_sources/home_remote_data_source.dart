import 'package:movie_discovery_app/core/network/api_endpoint.dart';
import 'package:movie_discovery_app/core/network/api_manager.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/movie_model.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/movie_response_model.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/person_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<MovieModel>> getTrendingMovies({int page = 1});
  Future<List<MovieModel>> getPopularMovies({int page = 1});
  Future<List<MovieModel>> getTopRatedMovies({int page = 1});
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1});
  Future<List<MovieModel>> getUpcomingMovies({int page = 1});
  Future<List<PersonModel>> getPopularPeople({int page = 1});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiManager apiManager;

  const HomeRemoteDataSourceImpl(this.apiManager);

  @override
  Future<List<MovieModel>> getTrendingMovies({int page = 1}) async {
    final response = await apiManager.get(
      ApiEndpoints.trendingMovies,
      queryParameters: {'page': page},
    );
    final data = MovieResponseModel.fromJson(response.data as Map<String, dynamic>);
    return data.results;
  }

  @override
  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    final response = await apiManager.get(
      ApiEndpoints.popularMovies,
      queryParameters: {'page': page},
    );
    final data = MovieResponseModel.fromJson(response.data as Map<String, dynamic>);
    return data.results;
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies({int page = 1}) async {
    final response = await apiManager.get(
      ApiEndpoints.topRatedMovies,
      queryParameters: {'page': page},
    );
    final data = MovieResponseModel.fromJson(response.data as Map<String, dynamic>);
    return data.results;
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1}) async {
    final response = await apiManager.get(
      ApiEndpoints.nowPlayingMovies,
      queryParameters: {'page': page},
    );
    final data = MovieResponseModel.fromJson(response.data as Map<String, dynamic>);
    return data.results;
  }

  @override
  Future<List<MovieModel>> getUpcomingMovies({int page = 1}) async {
    final response = await apiManager.get(
      ApiEndpoints.upcomingMovies,
      queryParameters: {'page': page},
    );
    final data = MovieResponseModel.fromJson(response.data as Map<String, dynamic>);
    return data.results;
  }

  @override
  Future<List<PersonModel>> getPopularPeople({int page = 1}) async {
    final response = await apiManager.get(
      ApiEndpoints.popularPeople,
      queryParameters: {'page': page},
    );
    final data = PersonResponseModel.fromJson(response.data as Map<String, dynamic>);
    return data.results;
  }
}

