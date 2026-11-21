import 'package:dio/dio.dart';
import 'package:movie_discovery_app/core/errors/failures.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/discover/data/data_sources/discover_remote_data_source.dart';
import 'package:movie_discovery_app/features/discover/domain/repositories/discover_repository.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/movie_response_model.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/person_model.dart';

class DiscoverRepositoryImpl implements DiscoverRepository {
  final DiscoverRemoteDataSource remoteDataSource;

  const DiscoverRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<MovieResponseModel>> getMovies({
    required String endpoint,
    int page = 1,
  }) {
    return _safeCall(
      () => remoteDataSource.getMovies(endpoint: endpoint, page: page),
    );
  }

  @override
  Future<ApiResult<MovieResponseModel>> getTvShows({
    required String endpoint,
    int page = 1,
  }) {
    return _safeCall(
      () => remoteDataSource.getTvShows(endpoint: endpoint, page: page),
    );
  }

  @override
  Future<ApiResult<PersonResponseModel>> getPeople({
    required String endpoint,
    int page = 1,
  }) {
    return _safeCall(
      () => remoteDataSource.getPeople(endpoint: endpoint, page: page),
    );
  }

  Future<ApiResult<T>> _safeCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return ApiSuccess(result);
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
