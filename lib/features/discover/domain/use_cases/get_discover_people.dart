import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/discover/domain/repositories/discover_repository.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/person_model.dart';

class GetDiscoverPeople {
  final DiscoverRepository repository;

  const GetDiscoverPeople(this.repository);

  Future<ApiResult<PersonResponseModel>> call({
    required String endpoint,
    int page = 1,
  }) {
    return repository.getPeople(endpoint: endpoint, page: page);
  }
}
