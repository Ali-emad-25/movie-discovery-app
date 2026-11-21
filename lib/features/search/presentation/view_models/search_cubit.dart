import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/core/network/api_result.dart';
import 'package:movie_discovery_app/features/search/domain/entities/search_item.dart';
import 'package:movie_discovery_app/features/search/domain/use_cases/search_use_case.dart';
import 'package:movie_discovery_app/features/search/presentation/view_models/search_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchUseCase searchUseCase;
  final FirebaseAuth firebaseAuth;
  Timer? _debounce;
  int _requestId = 0;

  SearchCubit({required this.searchUseCase, required this.firebaseAuth})
    : super(const SearchState()) {
    _loadRecentSearches();
  }

  String? get _recentSearchesKey {
    final user = firebaseAuth.currentUser;
    if (user == null || user.isAnonymous) return null;
    return 'search.recent_searches.${user.uid}';
  }

  Future<void> _loadRecentSearches() async {
    final key = _recentSearchesKey;
    if (key == null) {
      if (!isClosed) emit(state.copyWith(recentSearches: const []));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    if (!isClosed) {
      emit(
        state.copyWith(recentSearches: prefs.getStringList(key) ?? const []),
      );
    }
  }

  void updateQuery(String value) {
    final query = value.trimLeft();
    _debounce?.cancel();
    _requestId++;
    if (query.trim().isEmpty) {
      emit(
        state.copyWith(
          query: query,
          results: const [],
          isLoading: false,
          clearError: true,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        query: query,
        results: const [],
        isLoading: true,
        clearError: true,
      ),
    );
    _debounce = Timer(const Duration(seconds: 3), () => search(query));
  }

  Future<void> search([String? value]) async {
    final query = (value ?? state.query).trim();
    if (query.isEmpty) return;
    _debounce?.cancel();
    final requestId = ++_requestId;
    emit(
      state.copyWith(
        query: query,
        results: const [],
        isLoading: true,
        clearError: true,
      ),
    );

    final result = await searchUseCase(query);
    if (isClosed || requestId != _requestId) return;
    if (result is ApiSuccess<List<SearchItem>>) {
      emit(
        state.copyWith(
          results: result.data,
          isLoading: false,
          clearError: true,
        ),
      );
      await _saveRecentSearch(query);
    } else if (result is ApiError<List<SearchItem>>) {
      emit(
        state.copyWith(isLoading: false, errorMessage: result.failure.message),
      );
    }
  }

  Future<void> _saveRecentSearch(String query) async {
    final key = _recentSearchesKey;
    if (key == null) return;

    final recent = [
      query,
      ...state.recentSearches.where(
        (item) => item.toLowerCase() != query.toLowerCase(),
      ),
    ].take(8).toList();
    emit(state.copyWith(recentSearches: recent));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, recent);
  }

  void setSortBy(SearchSortBy value) => emit(state.copyWith(sortBy: value));
  void setScoreRange(double minimum, double maximum) =>
      emit(state.copyWith(minimumScore: minimum, maximumScore: maximum));
  void toggleGenre(int id) {
    final genres = {...state.selectedGenres};
    if (genres.contains(id)) {
      genres.remove(id);
    } else {
      genres.add(id);
    }
    emit(state.copyWith(selectedGenres: genres));
  }

  void setReleaseEra(int? startYear, [int? endYear]) => emit(
    startYear == null
        ? state.copyWith(clearStartYear: true, clearEndYear: true)
        : state.copyWith(
            startYear: startYear,
            endYear: endYear,
            clearEndYear: endYear == null,
          ),
  );

  void resetFilters() => emit(
    state.copyWith(
      sortBy: SearchSortBy.popularity,
      selectedGenres: const {},
      minimumScore: 0,
      maximumScore: 10,
      clearStartYear: true,
      clearEndYear: true,
    ),
  );

  void clearSearch() {
    _debounce?.cancel();
    _requestId++;
    emit(
      state.copyWith(
        query: '',
        results: const [],
        isLoading: false,
        clearError: true,
      ),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
