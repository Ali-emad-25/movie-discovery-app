import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/person.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/use_cases/home_use_cases.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/view_models/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTrendingMoviesUseCase getTrendingMoviesUseCase;
  final GetPopularMoviesUseCase getPopularMoviesUseCase;
  final GetTopRatedMoviesUseCase getTopRatedMoviesUseCase;
  final GetNowPlayingMoviesUseCase getNowPlayingMoviesUseCase;
  final GetUpcomingMoviesUseCase getUpcomingMoviesUseCase;
  final GetPopularPeopleUseCase getPopularPeopleUseCase;

  HomeCubit({
    required this.getTrendingMoviesUseCase,
    required this.getPopularMoviesUseCase,
    required this.getTopRatedMoviesUseCase,
    required this.getNowPlayingMoviesUseCase,
    required this.getUpcomingMoviesUseCase,
    required this.getPopularPeopleUseCase,
  }) : super(const HomeInitial());

  Future<void> fetchHomeData() async {
    emit(const HomeLoading());

    final results = await Future.wait([
      getTrendingMoviesUseCase(),
      getPopularMoviesUseCase(),
      getTopRatedMoviesUseCase(),
      getNowPlayingMoviesUseCase(),
      getUpcomingMoviesUseCase(),
      getPopularPeopleUseCase(),
    ]);

    final trendingRes = results[0] as ApiResult<List<Movie>>;
    final popularRes = results[1] as ApiResult<List<Movie>>;
    final topRatedRes = results[2] as ApiResult<List<Movie>>;
    final nowPlayingRes = results[3] as ApiResult<List<Movie>>;
    final upcomingRes = results[4] as ApiResult<List<Movie>>;
    final popularPeopleRes = results[5] as ApiResult<List<Person>>;

    if (trendingRes is ApiSuccess<List<Movie>> &&
        popularRes is ApiSuccess<List<Movie>> &&
        topRatedRes is ApiSuccess<List<Movie>> &&
        nowPlayingRes is ApiSuccess<List<Movie>> &&
        upcomingRes is ApiSuccess<List<Movie>> &&
        popularPeopleRes is ApiSuccess<List<Person>>) {
      emit(
        HomeLoaded(
          trendingMovies: trendingRes.data,
          popularMovies: popularRes.data,
          topRatedMovies: topRatedRes.data,
          nowPlayingMovies: nowPlayingRes.data,
          upcomingMovies: upcomingRes.data,
          popularPeople: popularPeopleRes.data,
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

  void setFilterIndex(int index) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      emit(current.copyWith(selectedFilterIndex: index));
    }
  }
}
