import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _themeKey = '__theme_key__';
  static const _colorKey = '__color_key__';

  Future<void> writeTheme(bool theme) async {
    await _prefs.setBool(_themeKey, theme);
  }

  Future<void> writeColor(int color) async {
    await _prefs.setInt(_colorKey, color);
  }

  (bool?, int?) readSettings() {
    return (_prefs.getBool(_themeKey), _prefs.getInt(_colorKey));
  }
}
