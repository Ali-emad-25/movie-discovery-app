import 'package:dio/dio.dart';
import 'package:movie_discovery_app/core/errors/failures.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/cast_details/data/data_sources/cast_details_remote_data_source.dart';
import 'package:movie_discovery_app/features/cast_details/domain/entities/cast_details.dart';
import 'package:movie_discovery_app/features/cast_details/domain/repositories/cast_details_repository.dart';

class CastDetailsRepositoryImpl implements CastDetailsRepository {
  final CastDetailsRemoteDataSource remoteDataSource;

  const CastDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResult<CastDetails>> getCastDetails(
    int personId, {
    required String language,
  }) async {
    try {
      final details = await remoteDataSource.getCastDetails(
        personId,
        language: language,
      );
      return ApiSuccess<CastDetails>(details);
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
