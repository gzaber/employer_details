import 'package:bloc_test/bloc_test.dart';
import 'package:details_repository/details_repository.dart';
import 'package:employer_details/app/app.dart';
import 'package:employer_details/details_overview/details_overview.dart';
import 'package:employer_details/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:settings_repository/settings_repository.dart';

class MockDetailsRepository extends Mock implements DetailsRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

void main() {
  late DetailsRepository detailsRepository;
  late SettingsRepository settingsRepository;
  late SettingsCubit settingsCubit;

  setUp(() {
    detailsRepository = MockDetailsRepository();
    settingsRepository = MockSettingsRepository();
    settingsCubit = MockSettingsCubit();

    when(() => settingsCubit.state).thenReturn(const SettingsState());
  });

  group('App', () {
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          detailsRepository: detailsRepository,
          settingsRepository: settingsRepository,
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    testWidgets('renders DetailsOverviewPage', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: detailsRepository,
          child: BlocProvider.value(
            value: settingsCubit,
            child: const AppView(),
          ),
        ),
      );

      expect(find.byType(DetailsOverviewPage), findsOneWidget);
    });

    testWidgets('shows SnackBar when exception occurs', (tester) async {
      whenListen(
          settingsCubit,
          Stream.fromIterable([
            const SettingsState(),
            const SettingsState(hasFailure: true),
          ]));

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: detailsRepository,
          child: BlocProvider.value(
            value: settingsCubit,
            child: const AppView(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
