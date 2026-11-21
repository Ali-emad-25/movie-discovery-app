import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/core/network/api_endpoint.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/discover/domain/use_cases/get_discover_movies.dart';
import 'package:movie_discovery_app/features/discover/domain/use_cases/get_discover_people.dart';
import 'package:movie_discovery_app/features/discover/domain/use_cases/get_discover_tv_shows.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/movie_response_model.dart';
import 'package:movie_discovery_app/features/home/home_tab/data/models/person_model.dart';

import 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  final GetDiscoverMovies getDiscoverMovies;
  final GetDiscoverTvShows getDiscoverTvShows;
  final GetDiscoverPeople getDiscoverPeople;

  int _page = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _requestId = 0;

  DiscoverCubit({
    required this.getDiscoverMovies,
    required this.getDiscoverTvShows,
    required this.getDiscoverPeople,
  }) : super(const DiscoverInitial());

  Future<void> fetchDiscoverData({
    DiscoverType type = DiscoverType.movies,
    DiscoverFilter filter = DiscoverFilter.all,
  }) async {
    final requestId = ++_requestId;

    _page = 1;
    _totalPages = 1;
    _isLoadingMore = false;
    _hasMore = true;

    emit(DiscoverLoading(type: type, filter: filter));

    switch (type) {
      case DiscoverType.movies:
        await _fetchMovies(filter, requestId);
        break;

      case DiscoverType.tvShows:
        await _fetchTvShows(filter, requestId);
        break;

      case DiscoverType.people:
        await _fetchPeople(filter, requestId);
        break;
    }
  }

  String _moviesEndpoint(DiscoverFilter filter) {
    return switch (filter) {
      DiscoverFilter.all ||
      DiscoverFilter.trending => ApiEndpoints.trendingMovies,
      DiscoverFilter.topRated => ApiEndpoints.topRatedMovies,
      DiscoverFilter.popular => ApiEndpoints.popularMovies,
      DiscoverFilter.nowPlaying => ApiEndpoints.nowPlayingMovies,
      DiscoverFilter.upcoming => ApiEndpoints.upcomingMovies,
    };
  }

  String _tvEndpoint(DiscoverFilter filter) {
    return switch (filter) {
      DiscoverFilter.all || DiscoverFilter.trending => ApiEndpoints.trendingTv,
      DiscoverFilter.topRated => ApiEndpoints.topRatedTv,
      _ => ApiEndpoints.popularTv,
    };
  }

  String _peopleEndpoint(DiscoverFilter filter) {
    return switch (filter) {
      DiscoverFilter.all ||
      DiscoverFilter.trending => ApiEndpoints.trendingPeople,
      _ => ApiEndpoints.popularPeople,
    };
  }

  Future<void> _fetchMovies(DiscoverFilter filter, int requestId) async {
    final result = await getDiscoverMovies(
      endpoint: _moviesEndpoint(filter),
      page: 1,
    );

    if (requestId != _requestId) return;

    switch (result) {
      case ApiSuccess<MovieResponseModel>(:final data):
        _page = data.page;
        _totalPages = data.totalPages;
        _hasMore = _page < _totalPages;

        emit(
          DiscoverLoaded(
            type: DiscoverType.movies,
            filter: filter,
            movies: data.results,
            hasMore: _hasMore,
          ),
        );

      case ApiError<MovieResponseModel>(:final failure):
        emit(
          DiscoverError(
            message: failure.message,
            type: DiscoverType.movies,
            filter: filter,
          ),
        );
    }
  }

  Future<void> _fetchTvShows(DiscoverFilter filter, int requestId) async {
    final result = await getDiscoverTvShows(
      endpoint: _tvEndpoint(filter),
      page: 1,
    );

    if (requestId != _requestId) return;

    switch (result) {
      case ApiSuccess<MovieResponseModel>(:final data):
        _page = data.page;
        _totalPages = data.totalPages;
        _hasMore = _page < _totalPages;

        emit(
          DiscoverLoaded(
            type: DiscoverType.tvShows,
            filter: filter,
            movies: data.results,
            hasMore: _hasMore,
          ),
        );

      case ApiError<MovieResponseModel>(:final failure):
        emit(
          DiscoverError(
            message: failure.message,
            type: DiscoverType.tvShows,
            filter: filter,
          ),
        );
    }
  }

  Future<void> _fetchPeople(DiscoverFilter filter, int requestId) async {
    final result = await getDiscoverPeople(
      endpoint: _peopleEndpoint(filter),
      page: 1,
    );

    if (requestId != _requestId) return;

    switch (result) {
      case ApiSuccess<PersonResponseModel>(:final data):
        _page = data.page;
        _totalPages = data.totalPages;
        _hasMore = _page < _totalPages;

        emit(
          DiscoverLoaded(
            type: DiscoverType.people,
            filter: filter,
            people: data.results,
            hasMore: _hasMore,
          ),
        );

      case ApiError<PersonResponseModel>(:final failure):
        emit(
          DiscoverError(
            message: failure.message,
            type: DiscoverType.people,
            filter: filter,
          ),
        );
    }
  }

  Future<void> loadMore() async {
    if (state is! DiscoverLoaded || _isLoadingMore || !_hasMore) {
      return;
    }

    final currentState = state as DiscoverLoaded;
    final requestId = _requestId;
    final nextPage = _page + 1;

    _isLoadingMore = true;

    emit(
      DiscoverLoaded(
        type: currentState.type,
        filter: currentState.filter,
        movies: currentState.movies,
        people: currentState.people,
        isLoadingMore: true,
        hasMore: _hasMore,
      ),
    );

    try {
      switch (currentState.type) {
        case DiscoverType.movies:
          final result = await getDiscoverMovies(
            endpoint: _moviesEndpoint(currentState.filter),
            page: nextPage,
          );

          if (requestId != _requestId) return;

          switch (result) {
            case ApiSuccess<MovieResponseModel>(:final data):
              _page = data.page;
              _totalPages = data.totalPages;
              _hasMore = _page < _totalPages;

              emit(
                DiscoverLoaded(
                  type: currentState.type,
                  filter: currentState.filter,
                  movies: [...currentState.movies, ...data.results],
                  hasMore: _hasMore,
                ),
              );

            case ApiError<MovieResponseModel>():
              _emitAfterLoadMore(currentState);
          }
          break;

        case DiscoverType.tvShows:
          final result = await getDiscoverTvShows(
            endpoint: _tvEndpoint(currentState.filter),
            page: nextPage,
          );

          if (requestId != _requestId) return;

          switch (result) {
            case ApiSuccess<MovieResponseModel>(:final data):
              _page = data.page;
              _totalPages = data.totalPages;
              _hasMore = _page < _totalPages;

              emit(
                DiscoverLoaded(
                  type: currentState.type,
                  filter: currentState.filter,
                  movies: [...currentState.movies, ...data.results],
                  hasMore: _hasMore,
                ),
              );

            case ApiError<MovieResponseModel>():
              _emitAfterLoadMore(currentState);
          }
          break;

        case DiscoverType.people:
          final result = await getDiscoverPeople(
            endpoint: _peopleEndpoint(currentState.filter),
            page: nextPage,
          );

          if (requestId != _requestId) return;

          switch (result) {
            case ApiSuccess<PersonResponseModel>(:final data):
              _page = data.page;
              _totalPages = data.totalPages;
              _hasMore = _page < _totalPages;

              emit(
                DiscoverLoaded(
                  type: currentState.type,
                  filter: currentState.filter,
                  people: [...currentState.people, ...data.results],
                  hasMore: _hasMore,
                ),
              );

            case ApiError<PersonResponseModel>():
              _emitAfterLoadMore(currentState);
          }
          break;
      }
    } finally {
      if (requestId == _requestId) {
        _isLoadingMore = false;
      }
    }
  }

  void _emitAfterLoadMore(DiscoverLoaded currentState) {
    emit(
      DiscoverLoaded(
        type: currentState.type,
        filter: currentState.filter,
        movies: currentState.movies,
        people: currentState.people,
        hasMore: _hasMore,
      ),
    );
  }

  Future<void> selectType(DiscoverType type) {
    return fetchDiscoverData(type: type);
  }

  Future<void> selectFilter(DiscoverFilter filter) async {
    final currentType = switch (state) {
      DiscoverLoaded(:final type) => type,
      DiscoverLoading(:final type) => type,
      DiscoverError(:final type) => type,
      _ => DiscoverType.movies,
    };

    await fetchDiscoverData(type: currentType, filter: filter);
  }
}
