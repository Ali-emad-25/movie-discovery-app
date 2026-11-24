import 'package:movie_discovery_app/core/network/api_manager.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/movie_response_model.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/person_model.dart';

import 'discover_remote_data_source.dart';

class DiscoverRemoteDataSourceImpl implements DiscoverRemoteDataSource {
  final ApiManager apiManager;

  DiscoverRemoteDataSourceImpl(this.apiManager);

  @override
  Future<MovieResponseModel> getMovies({
    required String endpoint,
    int page = 1,
  }) async {
    final response = await apiManager.get(
      endpoint,
      queryParameters: {'page': page},
    );

    return MovieResponseModel.fromJson(
      response.data,
      defaultMediaType: 'movie',
    );
  }

  @override
  Future<MovieResponseModel> getTvShows({
    required String endpoint,
    int page = 1,
  }) async {
    final response = await apiManager.get(
      endpoint,
      queryParameters: {'page': page},
    );

    return MovieResponseModel.fromJson(
      response.data,
      defaultMediaType: 'tv',
    );
  }

  @override
  Future<PersonResponseModel> getPeople({
    required String endpoint,
    int page = 1,
  }) async {
    final response = await apiManager.get(
      endpoint,
      queryParameters: {'page': page},
    );

    return PersonResponseModel.fromJson(response.data);
  }
}
