import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(const LightThemeState()) {
    _loadTheme();
  }

  bool get isDarkMode => state is DarkThemeState;

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);

    if (isClosed) return;

    emit(
      savedTheme == 'dark'
          ? const DarkThemeState()
          : const LightThemeState(),
    );
  }

  Future<void> changeTheme(ThemeState newState) async {
    final isDark = newState is DarkThemeState;

    emit(
      isDark
          ? const DarkThemeState()
          : const LightThemeState(),
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _themeKey,
      isDark ? 'dark' : 'light',
    );
  }

  Future<void> toggleTheme() async {
    final newState = isDarkMode
        ? const LightThemeState()
        : const DarkThemeState();

    await changeTheme(newState);
  }
}
