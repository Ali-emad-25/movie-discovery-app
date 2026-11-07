class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.themoviedb.org/3/';
  static const String imageBaseUrlW500 = 'https://image.tmdb.org/t/p/w500';
  static const String imageBaseUrlOriginal = 'https://image.tmdb.org/t/p/original';

  static const String tmdbToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MjQwYmQyMTliZDU3OGE5YzcwZTkwYjAyNzhiZGE3ZCIsIm5iZiI6MTc5MTk4ODcwNi42MjQsInN1YiI6IjZhY2Y5M2UyMTlkY2QxNTVmZDVkOGMxNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ZIe-gYxJlzisd5Sd8-Q_AFN_AfmauF9RAt-E7uj3EMY';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}

