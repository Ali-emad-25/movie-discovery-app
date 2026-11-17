import 'package:movie_discovery_app/core/network/api_endpoint.dart';
import 'package:movie_discovery_app/core/network/api_manager.dart';
import 'package:movie_discovery_app/features/search/data/models/search_item_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchItemModel>> search(String query, {int page = 1});
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiManager apiManager;

  const SearchRemoteDataSourceImpl(this.apiManager);

  @override
  Future<List<SearchItemModel>> search(String query, {int page = 1}) async {
    final response = await apiManager.get(
      ApiEndpoints.searchMulti,
      queryParameters: {'query': query, 'page': page, 'include_adult': false},
    );
    final body = response.data as Map<String, dynamic>;
    final results = body['results'] as List<dynamic>? ?? const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(SearchItemModel.fromJson)
        .toList();
  }
}
