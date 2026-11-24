import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/features/cast_details/presentation/views/cast_details_screen.dart';
import 'package:movie_discovery_app/features/discover/presentation/view_models/discover_cubit.dart';
import 'package:movie_discovery_app/features/discover/presentation/view_models/discover_state.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/filter_tabs.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/movie_card.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/person_card.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/content_tabs.dart';

class DiscoverTab extends StatelessWidget {
  const DiscoverTab({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<DiscoverCubit>();
      return const _DiscoverView();
    } catch (_) {
      return BlocProvider(
        create: (_) => getIt<DiscoverCubit>()..fetchDiscoverData(),
        child: const _DiscoverView(),
      );
    }
  }
}

class _DiscoverView extends StatelessWidget {
  const _DiscoverView();

  void _showMovieDetails(BuildContext context, Movie movie) {
    Navigator.pushNamed(
      context,
      AppRoutes.movieDetailsRouteName,
      arguments: movie.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            _buildTypeTabs(context),
            SizedBox(height: 10.h),
            _buildFilters(context),
            SizedBox(height: 20.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: _buildResults(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeTabs(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        final selectedType = _getSelectedType(state);

        return ContentTabs(
          tabKeys: const [
            'discover.tabs.movies',
            'discover.tabs.tv_shows',
            'discover.tabs.people',
          ],
          selectedIndex: DiscoverType.values.indexOf(selectedType),
          onTabSelected: (index) {
            context.read<DiscoverCubit>().selectType(
              DiscoverType.values[index],
            );
          },
        );
      },
    );
  }

  Widget _buildFilters(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        final type = _getSelectedType(state);
        final selectedFilter = _getSelectedFilter(state);

        final filters = switch (type) {
          DiscoverType.movies => [
            DiscoverFilter.all,
            DiscoverFilter.trending,
            DiscoverFilter.topRated,
            DiscoverFilter.popular,
            DiscoverFilter.nowPlaying,
            DiscoverFilter.upcoming,
          ],
          DiscoverType.tvShows => [
            DiscoverFilter.all,
            DiscoverFilter.trending,
            DiscoverFilter.topRated,
            DiscoverFilter.popular,
            DiscoverFilter.nowPlaying,
            DiscoverFilter.upcoming,
          ],
          DiscoverType.people => [
            DiscoverFilter.all,
            DiscoverFilter.trending,
            DiscoverFilter.popular,
          ],
        };

        return FilterTabs(
          tabKeys: filters.map(_filterName).toList(),
          selectedIndex: filters.indexOf(selectedFilter),
          onSelectTab: (index) {
            context.read<DiscoverCubit>().selectFilter(filters[index]);
          },
        );
      },
    );
  }

  Widget _buildResults() {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        if (state is DiscoverLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DiscoverError) {
          return Center(
            child: Text(state.message, textAlign: TextAlign.center),
          );
        }

        if (state is DiscoverLoaded) {
          if (state.type == DiscoverType.people) {
            if (state.people.isEmpty) {
              return const Center(child: Text('No people found'));
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.extentAfter < 400) {
                  context.read<DiscoverCubit>().loadMore();
                }
                return false;
              },
              child: GridView.builder(
                itemCount: state.people.length + (state.isLoadingMore ? 1 : 0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  if (index >= state.people.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return PersonCard(
                    person: state.people[index],
                    width: double.infinity,
                    imageSize: 100.r,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CastDetailsScreen(
                            personId: state.people[index].id,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }

          if (state.movies.isEmpty) {
            return const Center(child: Text('No results found'));
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.extentAfter < 400) {
                context.read<DiscoverCubit>().loadMore();
              }
              return false;
            },
            child: GridView.builder(
              itemCount: state.movies.length + (state.isLoadingMore ? 1 : 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
                childAspectRatio: 0.50,
              ),
              itemBuilder: (context, index) {
                if (index >= state.movies.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GestureDetector(
                  onTap: () => _showMovieDetails(context, state.movies[index]),
                  child: MovieCard(movie: state.movies[index]),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  DiscoverType _getSelectedType(DiscoverState state) {
    return switch (state) {
      DiscoverLoaded(:final type) => type,
      DiscoverLoading(:final type) => type,
      DiscoverError(:final type) => type,
      _ => DiscoverType.movies,
    };
  }

  DiscoverFilter _getSelectedFilter(DiscoverState state) {
    return switch (state) {
      DiscoverLoaded(:final filter) => filter,
      DiscoverLoading(:final filter) => filter,
      DiscoverError(:final filter) => filter,
      _ => DiscoverFilter.all,
    };
  }

  String _filterName(DiscoverFilter filter) {
    return switch (filter) {
      DiscoverFilter.all => 'home.tabs.all',
      DiscoverFilter.trending => 'home.tabs.trending',
      DiscoverFilter.topRated => 'home.tabs.top_rated',
      DiscoverFilter.popular => 'home.tabs.popular',
      DiscoverFilter.nowPlaying => 'home.tabs.now_playing',
      DiscoverFilter.upcoming => 'home.tabs.upcoming',
    };
  }
}
