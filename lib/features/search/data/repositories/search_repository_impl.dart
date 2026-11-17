import 'package:dio/dio.dart';
import 'package:movie_discovery_app/core/errors/failures.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:movie_discovery_app/features/search/domain/entities/search_item.dart';
import 'package:movie_discovery_app/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  const SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<List<SearchItem>>> search(
    String query, {
    int page = 1,
  }) async {
    try {
      final results = await remoteDataSource.search(query, page: page);
      return ApiSuccess<List<SearchItem>>(results);
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.connectionError) {
        return const ApiError(NetworkFailure());
      }
      return ApiError(ServerFailure(error.message ?? 'Server error occurred'));
    } catch (error) {
      return ApiError(UnknownFailure(error.toString()));
    }
  }
}
