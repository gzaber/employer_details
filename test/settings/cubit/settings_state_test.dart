import 'package:employer_details/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsState', () {
    SettingsState createState() => const SettingsState();

    test('constructor works properly', () {
      expect(() => createState(), returnsNormally);
    });

    test('supports value equality', () {
      expect(createState(), equals(createState()));
    });

    test('props are correct', () {
      expect(
        createState().props,
        [false, 4284955319, false],
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createState().copyWith(),
          equals(createState()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          createState().copyWith(
            isDarkTheme: null,
            colorSchemeCode: null,
            hasFailure: null,
          ),
          equals(createState()),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          createState().copyWith(
            isDarkTheme: true,
            colorSchemeCode: 123456,
            hasFailure: true,
          ),
          equals(
            const SettingsState(
              isDarkTheme: true,
              colorSchemeCode: 123456,
              hasFailure: true,
            ),
          ),
        );
      });
    });
  });
}
