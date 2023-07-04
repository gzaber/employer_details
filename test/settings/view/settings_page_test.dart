import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:employer_details/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

extension PumpWidgetX on WidgetTester {
  Future<void> pumpView({required SettingsCubit settingsCubit}) {
    return pumpWidget(
      BlocProvider.value(
        value: settingsCubit,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: SettingsPage(),
        ),
      ),
    );
  }
}

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

void main() {
  group('SettingsPage', () {
    late SettingsCubit mockSettingsCubit;

    setUp(() {
      mockSettingsCubit = MockSettingsCubit();
      when(() => mockSettingsCubit.state).thenReturn(const SettingsState());
    });

    testWidgets('invokes cubit method when toggle theme button is tapped',
        (tester) async {
      await tester.pumpView(settingsCubit: mockSettingsCubit);
      await tester
          .tap(find.byKey(const Key('settingsPageToggleThemeButtonKey')));

      verify(() => mockSettingsCubit.toggleTheme()).called(1);
    });

    testWidgets('shows SelectColorDialog when select color button is tapped',
        (tester) async {
      await tester.pumpView(settingsCubit: mockSettingsCubit);
      await tester
          .tap(find.byKey(const Key('settingsPageSelectColorButtonKey')));
      await tester.pumpAndSettle();

      expect(find.byType(SelectColorDialog), findsOneWidget);
    });

    testWidgets(
        'invokes cubit method when pops from SelectColorDialog with color',
        (tester) async {
      await tester.pumpView(settingsCubit: mockSettingsCubit);
      await tester
          .tap(find.byKey(const Key('settingsPageSelectColorButtonKey')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('selectColorDialogColorBoxKey0')));
      await tester.pumpAndSettle();

      verify(() => mockSettingsCubit.updateColorScheme(4293467747)).called(1);
    });

    testWidgets('shows SnackBar with info when failure occured',
        (tester) async {
      whenListen(
          mockSettingsCubit,
          Stream.fromIterable([
            const SettingsState(),
            const SettingsState(hasFailure: true),
          ]));

      await tester.pumpView(settingsCubit: mockSettingsCubit);
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text(AppLocalizationsEn().failureMessage),
        ),
        findsOneWidget,
      );
    });
  });
}
