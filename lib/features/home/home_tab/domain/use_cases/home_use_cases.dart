import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/person.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/repositories/home_repository.dart';

class GetTrendingMoviesUseCase {
  final HomeRepository repository;
  const GetTrendingMoviesUseCase(this.repository);

  Future<ApiResult<List<Movie>>> call({int page = 1}) {
    return repository.getTrendingMovies(page: page);
  }
}

class GetPopularMoviesUseCase {
  final HomeRepository repository;
  const GetPopularMoviesUseCase(this.repository);

  Future<ApiResult<List<Movie>>> call({int page = 1}) {
    return repository.getPopularMovies(page: page);
  }
}

class GetTopRatedMoviesUseCase {
  final HomeRepository repository;
  const GetTopRatedMoviesUseCase(this.repository);

  Future<ApiResult<List<Movie>>> call({int page = 1}) {
    return repository.getTopRatedMovies(page: page);
  }
}

class GetNowPlayingMoviesUseCase {
  final HomeRepository repository;
  const GetNowPlayingMoviesUseCase(this.repository);

  Future<ApiResult<List<Movie>>> call({int page = 1}) {
    return repository.getNowPlayingMovies(page: page);
  }
}

class GetUpcomingMoviesUseCase {
  final HomeRepository repository;
  const GetUpcomingMoviesUseCase(this.repository);

  Future<ApiResult<List<Movie>>> call({int page = 1}) {
    return repository.getUpcomingMovies(page: page);
  }
}

class GetPopularPeopleUseCase {
  final HomeRepository repository;
  const GetPopularPeopleUseCase(this.repository);

  Future<ApiResult<List<Person>>> call({int page = 1}) {
    return repository.getPopularPeople(page: page);
  }
}

