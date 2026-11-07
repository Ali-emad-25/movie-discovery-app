import 'package:dio/dio.dart';
import 'package:movie_discovery_app/core/errors/failures.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/movie_details/data/data_sources/movie_details_remote_data_source.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_details.dart';
import 'package:movie_discovery_app/features/movie_details/domain/repositories/movie_details_repository.dart';

class MovieDetailsRepositoryImpl implements MovieDetailsRepository {
  final MovieDetailsRemoteDataSource remoteDataSource;

  const MovieDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<MovieDetails>> getMovieDetails(int movieId) async {
    try {
      final details = await remoteDataSource.getMovieDetails(movieId);
      return ApiSuccess(details);
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

