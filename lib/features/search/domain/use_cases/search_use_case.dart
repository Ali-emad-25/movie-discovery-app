import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/search/domain/entities/search_item.dart';
import 'package:movie_discovery_app/features/search/domain/repositories/search_repository.dart';

class SearchUseCase {
  final SearchRepository repository;

  const SearchUseCase(this.repository);

  Future<ApiResult<List<SearchItem>>> call(String query, {int page = 1}) =>
      repository.search(query, page: page);
}
