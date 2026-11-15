class GenreHelper {
  GenreHelper._();

  static const Map<int, String> _enGenres = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Sci-Fi',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
  };

  static const Map<int, String> _arGenres = {
    28: 'أكشن',
    12: 'مغامرة',
    16: 'رسوم متحركة',
    35: 'كوميديا',
    80: 'جريمة',
    99: 'وثائقي',
    18: 'دراما',
    10751: 'عائلي',
    14: 'خيالي',
    36: 'تاريخي',
    27: 'رعب',
    10402: 'موسيقى',
    9648: 'غموض',
    10749: 'رومانسي',
    878: 'خيال علمي',
    10770: 'فيلم تلفزيوني',
    53: 'إثارة',
    10752: 'حرب',
    37: 'غرب أمريكي',
  };

  static String getGenreNames(List<int> genreIds, {String languageCode = 'en', int limit = 2}) {
    if (genreIds.isEmpty) return '';
    final map = languageCode == 'ar' ? _arGenres : _enGenres;
    final names = genreIds
        .map((id) => map[id])
        .where((name) => name != null)
        .take(limit)
        .cast<String>()
        .toList();
    return names.join(' • ');
  }
}

