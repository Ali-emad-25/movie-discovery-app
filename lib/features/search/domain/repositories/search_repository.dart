import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/search/domain/entities/search_item.dart';

abstract class SearchRepository {
  Future<ApiResult<List<SearchItem>>> search(String query, {int page = 1});
}
