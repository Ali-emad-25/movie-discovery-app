import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/movie_details/domain/use_cases/get_movie_details_use_case.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/view_models/movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final GetMovieDetailsUseCase getMovieDetailsUseCase;

  MovieDetailsCubit({
    required this.getMovieDetailsUseCase,
  }) : super(const MovieDetailsInitial());

  Future<void> fetchMovieDetails(int movieId) async {
    emit(const MovieDetailsLoading());

    final result = await getMovieDetailsUseCase(movieId);

    switch (result) {
      case ApiSuccess(:final data):
        emit(MovieDetailsLoaded(data));
      case ApiError(:final failure):
        emit(MovieDetailsError(failure.message));
    }
  }
}

