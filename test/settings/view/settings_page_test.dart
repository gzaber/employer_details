import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:employer_details/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

extension PumpWidgetX on WidgetTester {
  Future<void> pumpView({required SettingsCubit settingsCubit}) {
    return pumpWidget(
      BlocProvider.value(
        value: settingsCubit,
        child: const MaterialApp(
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
    late SettingsCubit settingsCubit;

    setUp(() {
      settingsCubit = MockSettingsCubit();
      when(() => settingsCubit.state).thenReturn(const SettingsState());
    });

    testWidgets('invokes cubit method when toggle theme button is tapped',
        (tester) async {
      await tester.pumpView(settingsCubit: settingsCubit);
      await tester
          .tap(find.byKey(const Key('settingsPageToggleThemeButtonKey')));

      verify(() => settingsCubit.toggleTheme()).called(1);
    });

    testWidgets('shows dialog when select color button is tapped',
        (tester) async {
      await tester.pumpView(settingsCubit: settingsCubit);
      await tester
          .tap(find.byKey(const Key('settingsPageSelectColorButtonKey')));
      await tester.pumpAndSettle();

      expect(find.byType(SelectColorDialog), findsOneWidget);
    });

    testWidgets('invokes cubit method when pops from dialog with color',
        (tester) async {
      await tester.pumpView(settingsCubit: settingsCubit);
      await tester
          .tap(find.byKey(const Key('settingsPageSelectColorButtonKey')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('selectColorDialogColorBoxKey0')));
      await tester.pumpAndSettle();

      verify(() => settingsCubit
          .updateColorScheme(settingsCubit.state.colorSchemeCode)).called(1);
    });
  });
}
