import 'package:movie_discovery_app/core/network/api_endpoint.dart';
import 'package:movie_discovery_app/core/network/api_manager.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/movie_model.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/movie_response_model.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/person_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<MovieModel>> getTrendingMovies({int page = 1});
  Future<List<MovieModel>> getPopularMovies({int page = 1});
  Future<List<MovieModel>> getTopRatedMovies({int page = 1});
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1});
  Future<List<MovieModel>> getUpcomingMovies({int page = 1});
  Future<List<PersonModel>> getPopularPeople({int page = 1});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiManager apiManager;

  const HomeRemoteDataSourceImpl(this.apiManager);

  @override
  Future<List<MovieModel>> getTrendingMovies({int page = 1}) async {
    final response = await apiManager.get(
      ApiEndpoints.trendingAll,
      queryParameters: {'page': page},
    );
    final data = MovieResponseModel.fromJson(response.data as Map<String, dynamic>);
    final results = List<MovieModel>.from(data.results);
    results.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    return results;
  }

  @override
  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    final responses = await Future.wait([
      apiManager.get(
        ApiEndpoints.popularMovies,
        queryParameters: {'page': page},
      ),
      apiManager.get(
        ApiEndpoints.popularTv,
        queryParameters: {'page': page},
      ),
    ]);

    final moviesData = MovieResponseModel.fromJson(
      responses[0].data as Map<String, dynamic>,
      defaultMediaType: 'movie',
    );
    final tvData = MovieResponseModel.fromJson(
      responses[1].data as Map<String, dynamic>,
      defaultMediaType: 'tv',
    );

    final combined = <MovieModel>[...moviesData.results, ...tvData.results];
    combined.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    return combined;
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies({int page = 1}) async {
    final responses = await Future.wait([
      apiManager.get(
        ApiEndpoints.topRatedMovies,
        queryParameters: {'page': page},
      ),
      apiManager.get(
        ApiEndpoints.topRatedTv,
        queryParameters: {'page': page},
      ),
    ]);

    final moviesData = MovieResponseModel.fromJson(
      responses[0].data as Map<String, dynamic>,
      defaultMediaType: 'movie',
    );
    final tvData = MovieResponseModel.fromJson(
      responses[1].data as Map<String, dynamic>,
      defaultMediaType: 'tv',
    );

    final combined = <MovieModel>[...moviesData.results, ...tvData.results];
    combined.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    return combined;
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1}) async {
    final responses = await Future.wait([
      apiManager.get(
        ApiEndpoints.nowPlayingMovies,
        queryParameters: {'page': page},
      ),
      apiManager.get(
        ApiEndpoints.onTheAirTv,
        queryParameters: {'page': page},
      ),
    ]);

    final moviesData = MovieResponseModel.fromJson(
      responses[0].data as Map<String, dynamic>,
      defaultMediaType: 'movie',
    );
    final tvData = MovieResponseModel.fromJson(
      responses[1].data as Map<String, dynamic>,
      defaultMediaType: 'tv',
    );

    final combined = <MovieModel>[...moviesData.results, ...tvData.results];
    combined.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    return combined;
  }

  @override
  Future<List<MovieModel>> getUpcomingMovies({int page = 1}) async {
    final response = await apiManager.get(
      ApiEndpoints.upcomingMovies,
      queryParameters: {'page': page},
    );
    final data = MovieResponseModel.fromJson(
      response.data as Map<String, dynamic>,
      defaultMediaType: 'movie',
    );

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final list = data.results.where((movie) {
      if (movie.releaseDate.isEmpty) return false;
      final release = DateTime.tryParse(movie.releaseDate);
      if (release == null) return false;
      return !release.isBefore(today);
    }).toList();

    // If page 1 had past movies and fewer than 10 remain, fetch page 2
    if (page == 1 && list.length < 10) {
      try {
        final page2Response = await apiManager.get(
          ApiEndpoints.upcomingMovies,
          queryParameters: {'page': 2},
        );
        final page2Data = MovieResponseModel.fromJson(
          page2Response.data as Map<String, dynamic>,
          defaultMediaType: 'movie',
        );
        final page2Upcoming = page2Data.results.where((movie) {
          if (movie.releaseDate.isEmpty) return false;
          final release = DateTime.tryParse(movie.releaseDate);
          if (release == null) return false;
          return !release.isBefore(today);
        });
        list.addAll(page2Upcoming);
      } catch (_) {}
    }

    // Sort ascending by release date (closest to today first)
    list.sort((a, b) {
      final dateA = DateTime.tryParse(a.releaseDate) ?? today;
      final dateB = DateTime.tryParse(b.releaseDate) ?? today;
      return dateA.compareTo(dateB);
    });

    return list;
  }

  @override
  Future<List<PersonModel>> getPopularPeople({int page = 1}) async {
    final response = await apiManager.get(
      ApiEndpoints.popularPeople,
      queryParameters: {'page': page},
    );
    final data = PersonResponseModel.fromJson(response.data as Map<String, dynamic>);
    return data.results;
  }
}

