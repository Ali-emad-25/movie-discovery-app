import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/person.dart';

enum DiscoverType { movies, tvShows, people }

enum DiscoverFilter { all, trending, topRated, popular, nowPlaying, upcoming }

sealed class DiscoverState {
  const DiscoverState();
}

final class DiscoverInitial extends DiscoverState {
  const DiscoverInitial();
}

final class DiscoverLoading extends DiscoverState {
  final DiscoverType type;
  final DiscoverFilter filter;

  const DiscoverLoading({required this.type, required this.filter});
}

final class DiscoverLoaded extends DiscoverState {
  final DiscoverType type;
  final DiscoverFilter filter;
  final List<Movie> movies;
  final List<Person> people;
  final bool isLoadingMore;
  final bool hasMore;

  const DiscoverLoaded({
    required this.type,
    required this.filter,
    this.movies = const [],
    this.people = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
  });
}

final class DiscoverError extends DiscoverState {
  final String message;
  final DiscoverType type;
  final DiscoverFilter filter;

  const DiscoverError({
    required this.message,
    required this.type,
    required this.filter,
  });
}
