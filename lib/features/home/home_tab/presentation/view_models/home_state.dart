import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  final List<Movie> trendingMovies;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<Movie> nowPlayingMovies;
  final int selectedGenreIndex;

  const HomeLoaded({
    required this.trendingMovies,
    required this.popularMovies,
    required this.topRatedMovies,
    required this.nowPlayingMovies,
    this.selectedGenreIndex = 0,
  });

  Movie? get featuredMovie =>
      nowPlayingMovies.isNotEmpty ? nowPlayingMovies.first : null;

  HomeLoaded copyWith({
    List<Movie>? trendingMovies,
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    List<Movie>? nowPlayingMovies,
    int? selectedGenreIndex,
  }) {
    return HomeLoaded(
      trendingMovies: trendingMovies ?? this.trendingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      selectedGenreIndex: selectedGenreIndex ?? this.selectedGenreIndex,
    );
  }
}

final class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}

