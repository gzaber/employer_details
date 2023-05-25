import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _settingsKey = "__settings_key__";

  Future<void> write(int setting) async {
    await _prefs.setInt(_settingsKey, setting);
  }

  int? read() {
    return _prefs.getInt(_settingsKey);
  }
}
