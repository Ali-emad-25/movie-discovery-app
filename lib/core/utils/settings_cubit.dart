import 'package:flutter_bloc/flutter_bloc.dart';
import '../network/api_result.dart';

import 'settings_use_cases.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final LoadSettingsUseCase loadSettingsUseCase;
  final SaveSettingsUseCase saveSettingsUseCase;

  SettingsCubit({
    required this.loadSettingsUseCase,
    required this.saveSettingsUseCase,
  }) : super(const SettingsState());

  Future<void> loadSettings() async {
    final result = await loadSettingsUseCase();
    if (isClosed) return;
    switch (result) {
      case ApiSuccess(data: final settings):
        emit(SettingsState(settings: settings));
      case ApiError():
        emit(const SettingsState(error: 'common.settings_load_error'));
    }
  }

  Future<void> setDarkMode(bool value) =>
      _save(state.settings.copyWith(isDark: value));

  Future<void> setLanguage(String languageCode) =>
      _save(state.settings.copyWith(languageCode: languageCode));

  Future<void> _save(AppSettings settings) async {
    if (state.isSaving) return;
    final previous = state.settings;
    emit(SettingsState(settings: previous, isSaving: true));
    final result = await saveSettingsUseCase(settings);
    if (isClosed) return;
    switch (result) {
      case ApiSuccess():
        emit(SettingsState(settings: settings));
      case ApiError():
        emit(SettingsState(settings: previous, error: 'common.save_error'));
    }
  }
}

class SettingsState {
  final AppSettings settings;
  final bool isSaving;
  final String? error;
  const SettingsState({
    this.settings = const AppSettings(),
    this.isSaving = false,
    this.error,
  });
}
