import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings_repository/src/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SettingsRepository', () {
    late SharedPreferences prefs;
    late SettingsRepository settingsRepository;

    setUp(() {
      prefs = MockSharedPreferences();
      settingsRepository = SettingsRepository(prefs);
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => SettingsRepository(prefs), returnsNormally);
      });
    });

    group('writeTheme', () {
      test('saves theme', () {
        when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);

        expect(settingsRepository.writeTheme(true), completes);
        verify(() => prefs.setBool('__theme_key__', true)).called(1);
      });
    });

    group('writeColor', () {
      test('saves color', () {
        when(() => prefs.setInt(any(), any())).thenAnswer((_) async => true);

        expect(settingsRepository.writeColor(1234), completes);
        verify(() => prefs.setInt('__color_key__', 1234)).called(1);
      });
    });

    group('readSettings', () {
      test('returns theme and color when settings exist', () {
        when(() => prefs.getBool('__theme_key__')).thenReturn(true);
        when(() => prefs.getInt('__color_key__')).thenReturn(1234);

        expect(settingsRepository.readSettings(), equals((true, 1234)));
        verify(() => prefs.getBool('__theme_key__')).called(1);
        verify(() => prefs.getInt('__color_key__')).called(1);
      });

      test('returns null and null when settings don\'t exist', () {
        when(() => prefs.getBool('__theme_key__')).thenReturn(null);
        when(() => prefs.getInt('__color_key__')).thenReturn(null);

        expect(settingsRepository.readSettings(), equals((null, null)));
        verify(() => prefs.getBool('__theme_key__')).called(1);
        verify(() => prefs.getInt('__color_key__')).called(1);
      });
    });
  });
}
