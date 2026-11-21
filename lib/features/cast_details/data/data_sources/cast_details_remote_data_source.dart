import 'package:movie_discovery_app/core/network/api_endpoint.dart';
import 'package:movie_discovery_app/core/network/api_manager.dart';
import 'package:movie_discovery_app/features/cast_details/data/models/cast_details_model.dart';

abstract class CastDetailsRemoteDataSource {
  Future<CastDetailsModel> getCastDetails(
    int personId, {
    required String language,
  });
}

class CastDetailsRemoteDataSourceImpl implements CastDetailsRemoteDataSource {
  final ApiManager apiManager;

  const CastDetailsRemoteDataSourceImpl(this.apiManager);

  @override
  Future<CastDetailsModel> getCastDetails(
    int personId, {
    required String language,
  }) async {
    final response = await apiManager.get(
      '${ApiEndpoints.personDetails}$personId',
      queryParameters: {
        'language': language,
        'append_to_response': 'movie_credits,tv_credits',
      },
    );
    return CastDetailsModel.fromJson(response.data as Map<String, dynamic>);
  }
}
