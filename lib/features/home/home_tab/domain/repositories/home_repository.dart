import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/person.dart';

abstract class HomeRepository {
  Future<ApiResult<List<Movie>>> getTrendingMovies({int page = 1});
  Future<ApiResult<List<Movie>>> getPopularMovies({int page = 1});
  Future<ApiResult<List<Movie>>> getTopRatedMovies({int page = 1});
  Future<ApiResult<List<Movie>>> getNowPlayingMovies({int page = 1});
  Future<ApiResult<List<Movie>>> getUpcomingMovies({int page = 1});
  Future<ApiResult<List<Person>>> getPopularPeople({int page = 1});
}

