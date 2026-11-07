import 'package:dio/dio.dart';
import 'package:movie_discovery_app/core/errors/failures.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/data_sources/home_remote_data_source.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  const HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<List<Movie>>> getTrendingMovies({int page = 1}) async {
    return _safeCall(() => remoteDataSource.getTrendingMovies(page: page));
  }

  @override
  Future<ApiResult<List<Movie>>> getPopularMovies({int page = 1}) async {
    return _safeCall(() => remoteDataSource.getPopularMovies(page: page));
  }

  @override
  Future<ApiResult<List<Movie>>> getTopRatedMovies({int page = 1}) async {
    return _safeCall(() => remoteDataSource.getTopRatedMovies(page: page));
  }

  @override
  Future<ApiResult<List<Movie>>> getNowPlayingMovies({int page = 1}) async {
    return _safeCall(() => remoteDataSource.getNowPlayingMovies(page: page));
  }

  Future<ApiResult<List<Movie>>> _safeCall(
    Future<List<Movie>> Function() call,
  ) async {
    try {
      final movies = await call();
      return ApiSuccess(movies);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const ApiError(NetworkFailure());
      }
      return ApiError(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      return ApiError(UnknownFailure(e.toString()));
    }
  }
}

