import 'package:movie_discovery_app/features/search/domain/entities/search_item.dart';

enum SearchSortBy { popularity, rating, releaseDate, titleAZ }

class SearchState {
  final String query;
  final List<SearchItem> results;
  final List<String> recentSearches;
  final bool isLoading;
  final bool isDebouncing;
  final String? errorMessage;
  final SearchSortBy sortBy;
  final Set<int> selectedGenres;
  final double minimumScore;
  final double maximumScore;
  final int? startYear;
  final int? endYear;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.recentSearches = const [],
    this.isLoading = false,
    this.isDebouncing = false,
    this.errorMessage,
    this.sortBy = SearchSortBy.popularity,
    this.selectedGenres = const {},
    this.minimumScore = 0,
    this.maximumScore = 10,
    this.startYear,
    this.endYear,
  });

  bool get hasQuery => query.trim().isNotEmpty;

  List<SearchItem> get visibleResults {
    final visible = results.where((item) {
      final isPerson = item.type == SearchItemType.person;
      final genreMatches =
          selectedGenres.isEmpty ||
          isPerson ||
          item.genreIds.any(selectedGenres.contains);
      final scoreMatches =
          isPerson ||
          (item.rating >= minimumScore && item.rating <= maximumScore);
      final yearMatches =
          startYear == null ||
          isPerson ||
          (item.year != null &&
              item.year! >= startYear! &&
              (endYear == null || item.year! <= endYear!));
      return genreMatches && scoreMatches && yearMatches;
    }).toList();

    switch (sortBy) {
      case SearchSortBy.popularity:
        visible.sort((a, b) => b.popularity.compareTo(a.popularity));
        break;
      case SearchSortBy.rating:
        visible.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SearchSortBy.releaseDate:
        visible.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
        break;
      case SearchSortBy.titleAZ:
        visible.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
    }
    return visible;
  }

  SearchState copyWith({
    String? query,
    List<SearchItem>? results,
    List<String>? recentSearches,
    bool? isLoading,
    bool? isDebouncing,
    String? errorMessage,
    bool clearError = false,
    SearchSortBy? sortBy,
    Set<int>? selectedGenres,
    double? minimumScore,
    double? maximumScore,
    int? startYear,
    int? endYear,
    bool clearStartYear = false,
    bool clearEndYear = false,
  }) => SearchState(
    query: query ?? this.query,
    results: results ?? this.results,
    recentSearches: recentSearches ?? this.recentSearches,
    isLoading: isLoading ?? this.isLoading,
    isDebouncing: isDebouncing ?? this.isDebouncing,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    sortBy: sortBy ?? this.sortBy,
    selectedGenres: selectedGenres ?? this.selectedGenres,
    minimumScore: minimumScore ?? this.minimumScore,
    maximumScore: maximumScore ?? this.maximumScore,
    startYear: clearStartYear ? null : startYear ?? this.startYear,
    endYear: clearEndYear ? null : endYear ?? this.endYear,
  );
}
