import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/use_cases/home_use_cases.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/view_models/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTrendingMoviesUseCase getTrendingMoviesUseCase;
  final GetPopularMoviesUseCase getPopularMoviesUseCase;
  final GetTopRatedMoviesUseCase getTopRatedMoviesUseCase;
  final GetNowPlayingMoviesUseCase getNowPlayingMoviesUseCase;

  HomeCubit({
    required this.getTrendingMoviesUseCase,
    required this.getPopularMoviesUseCase,
    required this.getTopRatedMoviesUseCase,
    required this.getNowPlayingMoviesUseCase,
  }) : super(const HomeInitial());

  Future<void> fetchHomeData() async {
    emit(const HomeLoading());

    final results = await Future.wait([
      getTrendingMoviesUseCase(),
      getPopularMoviesUseCase(),
      getTopRatedMoviesUseCase(),
      getNowPlayingMoviesUseCase(),
    ]);

    final trendingRes = results[0];
    final popularRes = results[1];
    final topRatedRes = results[2];
    final nowPlayingRes = results[3];

    if (trendingRes is ApiSuccess &&
        popularRes is ApiSuccess &&
        topRatedRes is ApiSuccess &&
        nowPlayingRes is ApiSuccess) {
      emit(
        HomeLoaded(
          trendingMovies: (trendingRes as ApiSuccess).data,
          popularMovies: (popularRes as ApiSuccess).data,
          topRatedMovies: (topRatedRes as ApiSuccess).data,
          nowPlayingMovies: (nowPlayingRes as ApiSuccess).data,
        ),
      );
    } else {
      String errorMessage = 'Failed to load movies. Please try again.';
      for (final res in results) {
        if (res case ApiError(:final failure)) {
          errorMessage = failure.message;
          break;
        }
      }
      emit(HomeError(errorMessage));
    }
  }

  void selectGenre(int index) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      emit(current.copyWith(selectedGenreIndex: index));
    }
  }
}

