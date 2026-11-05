import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../errors/failures.dart';
import '../network/api_result.dart';

import 'settings_use_cases.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const storageKey = 'app_settings';
  const SettingsRepositoryImpl();

  @override
  Future<ApiResult<AppSettings>> loadSettings() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final stored = preferences.getString(storageKey);
      if (stored == null) return const ApiSuccess(AppSettings());
      final data = jsonDecode(stored);
      if (data is! Map<String, dynamic>) {
        return const ApiSuccess(AppSettings());
      }
      return ApiSuccess(
        AppSettings(
          isDark: data['dark'] == true,
          languageCode: data['language'] == 'ar' ? 'ar' : 'en',
        ),
      );
    } on FormatException {
      return const ApiSuccess(AppSettings());
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<void>> saveSettings(AppSettings settings) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setString(
        storageKey,
        jsonEncode({
          'dark': settings.isDark,
          'language': settings.languageCode,
        }),
      );
      if (!saved) return const ApiError(UnknownFailure());
      return const ApiSuccess(null);
    } catch (_) {
      return const ApiError(UnknownFailure());
    }
  }
}
