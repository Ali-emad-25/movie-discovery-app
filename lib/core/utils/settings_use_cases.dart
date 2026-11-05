import '../network/api_result.dart';

abstract class SettingsRepository {
  Future<ApiResult<AppSettings>> loadSettings();
  Future<ApiResult<void>> saveSettings(AppSettings settings);
}

class AppSettings {
  final bool isDark;
  final String languageCode;
  const AppSettings({this.isDark = false, this.languageCode = 'en'});

  AppSettings copyWith({bool? isDark, String? languageCode}) => AppSettings(
    isDark: isDark ?? this.isDark,
    languageCode: languageCode ?? this.languageCode,
  );
}

class LoadSettingsUseCase {
  final SettingsRepository repository;
  const LoadSettingsUseCase(this.repository);
  Future<ApiResult<AppSettings>> call() => repository.loadSettings();
}

class SaveSettingsUseCase {
  final SettingsRepository repository;
  const SaveSettingsUseCase(this.repository);
  Future<ApiResult<void>> call(AppSettings settings) =>
      repository.saveSettings(settings);
}
