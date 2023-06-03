import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_repository/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required SettingsRepository settingsRepository,
  })  : _settingsRepository = settingsRepository,
        super(const SettingsState());

  final SettingsRepository _settingsRepository;

  void readSettings() {
    try {
      final (isDarkTheme, colorSchemeCode) = _settingsRepository.readSettings();
      emit(
        state.copyWith(
          isDarkTheme: isDarkTheme ?? state.isDarkTheme,
          colorSchemeCode: colorSchemeCode ?? state.colorSchemeCode,
        ),
      );
    } catch (_) {
      emit(state.copyWith(hasException: true));
    }
  }

  void toggleTheme() async {
    try {
      await _settingsRepository.writeTheme(!state.isDarkTheme);
      emit(state.copyWith(isDarkTheme: !state.isDarkTheme));
    } catch (_) {
      emit(state.copyWith(hasException: true));
    }
  }

  void updateColorScheme(int colorSchemeCode) async {
    try {
      await _settingsRepository.writeColor(colorSchemeCode);
      emit(state.copyWith(colorSchemeCode: colorSchemeCode));
    } catch (_) {
      emit(state.copyWith(hasException: true));
    }
  }
}
