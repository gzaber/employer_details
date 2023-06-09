part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.isDarkTheme = false,
    this.colorSchemeCode = 4284955319,
    this.hasFailure = false,
  });

  final bool isDarkTheme;
  final int colorSchemeCode;
  final bool hasFailure;

  SettingsState copyWith({
    bool? isDarkTheme,
    int? colorSchemeCode,
    bool? hasFailure,
  }) {
    return SettingsState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      colorSchemeCode: colorSchemeCode ?? this.colorSchemeCode,
      hasFailure: hasFailure ?? this.hasFailure,
    );
  }

  @override
  List<Object> get props => [isDarkTheme, colorSchemeCode, hasFailure];
}
