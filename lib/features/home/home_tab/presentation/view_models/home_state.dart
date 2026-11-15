import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/person.dart';

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
  final List<Movie> upcomingMovies;
  final List<Person> popularPeople;
  final int selectedFilterIndex;

  const HomeLoaded({
    required this.trendingMovies,
    required this.popularMovies,
    required this.topRatedMovies,
    required this.nowPlayingMovies,
    required this.upcomingMovies,
    required this.popularPeople,
    this.selectedFilterIndex = 0,
  });

  Movie? get featuredMovie =>
      nowPlayingMovies.isNotEmpty ? nowPlayingMovies.first : null;

  HomeLoaded copyWith({
    List<Movie>? trendingMovies,
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    List<Movie>? nowPlayingMovies,
    List<Movie>? upcomingMovies,
    List<Person>? popularPeople,
    int? selectedFilterIndex,
  }) {
    return HomeLoaded(
      trendingMovies: trendingMovies ?? this.trendingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      popularPeople: popularPeople ?? this.popularPeople,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
    );
  }
}

final class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}
