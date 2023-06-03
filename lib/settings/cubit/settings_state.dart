part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.isDarkTheme = false,
    this.colorSchemeCode = 4284955319,
    this.hasException = false,
  });

  final bool isDarkTheme;
  final int colorSchemeCode;
  final bool hasException;

  SettingsState copyWith({
    bool? isDarkTheme,
    int? colorSchemeCode,
    bool? hasException,
  }) {
    return SettingsState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      colorSchemeCode: colorSchemeCode ?? this.colorSchemeCode,
      hasException: hasException ?? this.hasException,
    );
  }

  @override
  List<Object?> get props => [isDarkTheme, colorSchemeCode];
}
