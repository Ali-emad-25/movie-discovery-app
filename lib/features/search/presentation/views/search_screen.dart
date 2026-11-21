import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/cast_details/presentation/views/cast_details_screen.dart';
import 'package:movie_discovery_app/features/search/domain/entities/search_item.dart';
import 'package:movie_discovery_app/features/search/presentation/view_models/search_cubit.dart';
import 'package:movie_discovery_app/features/search/presentation/view_models/search_state.dart';
import 'package:movie_discovery_app/features/search/presentation/widgets/search_empty_state.dart';
import 'package:movie_discovery_app/features/search/presentation/widgets/search_field.dart';
import 'package:movie_discovery_app/features/search/presentation/widgets/search_filters_sheet.dart';
import 'package:movie_discovery_app/features/search/presentation/widgets/search_header.dart';
import 'package:movie_discovery_app/features/search/presentation/widgets/search_results_view.dart';
import 'package:movie_discovery_app/features/search/presentation/widgets/search_suggestions.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<SearchCubit>(),
    child: const _SearchScreenBody(),
  );
}

class _SearchScreenBody extends StatefulWidget {
  const _SearchScreenBody();

  @override
  State<_SearchScreenBody> createState() => _SearchScreenBodyState();
}

class _SearchScreenBodyState extends State<_SearchScreenBody> {
  late final TextEditingController _controller;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';
  String _t(String en, String ar) => _isArabic ? ar : en;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectQuery(String query) {
    _controller.text = query;
    context.read<SearchCubit>().search(query);
    FocusScope.of(context).unfocus();
  }

  void _clearQuery() {
    _controller.clear();
    context.read<SearchCubit>().clearSearch();
  }

  void _openFilters() {
    final cubit = context.read<SearchCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: SearchFiltersSheet(isArabic: _isArabic),
      ),
    );
  }

  void _openPersonDetails(SearchItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CastDetailsScreen(personId: item.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.bgDarkColor : AppColors.bgLightColor;
    final primaryColor = isDark
        ? AppColors.primaryTextDarkColor
        : AppColors.primaryColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            SearchHeader(isArabic: _isArabic),
            SearchField(
              controller: _controller,
              isArabic: _isArabic,
              onOpenFilters: _openFilters,
              onClear: _clearQuery,
            ),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (!state.hasQuery) {
                    return SearchSuggestions(
                      state: state,
                      isArabic: _isArabic,
                      onSelectQuery: _selectQuery,
                    );
                  }
                  if (state.isLoading && state.results.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    );
                  }
                  if (state.errorMessage != null && state.results.isEmpty) {
                    return SearchEmptyState(
                      icon: Icons.wifi_off_rounded,
                      title: state.errorMessage!,
                      subtitle: _t(
                        'Check your connection and try again.',
                        'تحقق من اتصالك وحاول مرة أخرى.',
                      ),
                      action: _t('Try Again', 'حاول مرة أخرى'),
                      onAction: () => context.read<SearchCubit>().search(),
                    );
                  }
                  final results = state.visibleResults;
                  if (!state.isLoading && results.isEmpty) {
                    return SearchEmptyState(
                      icon: Icons.manage_search_rounded,
                      title: _t('No Results Found', 'لا توجد نتائج'),
                      action: _t('Clear Search', 'مسح البحث'),
                      onAction: _clearQuery,
                    );
                  }
                  return SearchResultsView(
                    state: state,
                    results: results,
                    isArabic: _isArabic,
                    onPersonTap: _openPersonDetails,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
