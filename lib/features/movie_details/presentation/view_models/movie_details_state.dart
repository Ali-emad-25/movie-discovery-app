import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_details.dart';

sealed class MovieDetailsState {
  const MovieDetailsState();
}

final class MovieDetailsInitial extends MovieDetailsState {
  const MovieDetailsInitial();
}

final class MovieDetailsLoading extends MovieDetailsState {
  const MovieDetailsLoading();
}

final class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetails movieDetails;

  const MovieDetailsLoaded(this.movieDetails);
}

final class MovieDetailsError extends MovieDetailsState {
  final String message;

  const MovieDetailsError(this.message);
}

