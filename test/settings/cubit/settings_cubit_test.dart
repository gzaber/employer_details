import 'package:bloc_test/bloc_test.dart';
import 'package:employer_details/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:settings_repository/settings_repository.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  group('SettingsCubit', () {
    late SettingsRepository settingsRepository;

    SettingsCubit createCubit() =>
        SettingsCubit(settingsRepository: settingsRepository);

    setUp(() {
      settingsRepository = MockSettingsRepository();
    });

    test('constructor works properly', () {
      expect(() => createCubit(), returnsNormally);
    });

    test('initial state is correct', () {
      expect(
        createCubit().state,
        equals(const SettingsState()),
      );
    });

    group('readSettings', () {
      blocTest<SettingsCubit, SettingsState>(
        'emits state with theme and color when successfully found',
        setUp: () {
          when(() => settingsRepository.readSettings())
              .thenAnswer((_) => (true, 12345));
        },
        build: () => createCubit(),
        act: (cubit) => cubit.readSettings(),
        expect: () =>
            [const SettingsState(isDarkTheme: true, colorSchemeCode: 12345)],
        verify: (_) {
          verify(() => settingsRepository.readSettings()).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits state with existing theme and color when settings not found',
        setUp: () {
          when(() => settingsRepository.readSettings())
              .thenAnswer((_) => (null, null));
        },
        build: () => createCubit(),
        act: (cubit) => cubit.readSettings(),
        expect: () => [
          const SettingsState(isDarkTheme: false, colorSchemeCode: 4284955319)
        ],
        verify: (_) {
          verify(() => settingsRepository.readSettings()).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits state with failure acknowledgement when failure occurs',
        setUp: () {
          when(() => settingsRepository.readSettings()).thenThrow(Exception());
        },
        build: () => createCubit(),
        act: (cubit) => cubit.readSettings(),
        expect: () => [const SettingsState(hasFailure: true)],
        verify: (_) {
          verify(() => settingsRepository.readSettings()).called(1);
        },
      );
    });

    group('toggleTheme', () {
      blocTest<SettingsCubit, SettingsState>(
        'emits state with toggled theme',
        setUp: () {
          when(() => settingsRepository.writeTheme(any()))
              .thenAnswer((_) async {});
        },
        build: () => createCubit(),
        act: (cubit) => cubit.toggleTheme(),
        expect: () => [const SettingsState(isDarkTheme: true)],
        verify: (_) {
          verify(() => settingsRepository.writeTheme(true)).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits state with failure acknowledgement when failure occurs',
        setUp: () {
          when(() => settingsRepository.writeTheme(any()))
              .thenThrow(Exception());
        },
        build: () => createCubit(),
        act: (cubit) => cubit.toggleTheme(),
        expect: () => [const SettingsState(hasFailure: true)],
        verify: (_) {
          verify(() => settingsRepository.writeTheme(true)).called(1);
        },
      );
    });

    group('updateColorScheme', () {
      blocTest<SettingsCubit, SettingsState>(
        'emits state with updated color scheme',
        setUp: () {
          when(() => settingsRepository.writeColor(any()))
              .thenAnswer((_) async {});
        },
        build: () => createCubit(),
        act: (cubit) => cubit.updateColorScheme(12345),
        expect: () => [const SettingsState(colorSchemeCode: 12345)],
        verify: (_) {
          verify(() => settingsRepository.writeColor(12345)).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits state with failure acknowledgement when failure occurs',
        setUp: () {
          when(() => settingsRepository.writeColor(any()))
              .thenThrow(Exception());
        },
        build: () => createCubit(),
        act: (cubit) => cubit.updateColorScheme(12345),
        expect: () => [const SettingsState(hasFailure: true)],
        verify: (_) {
          verify(() => settingsRepository.writeColor(12345)).called(1);
        },
      );
    });
  });
}
