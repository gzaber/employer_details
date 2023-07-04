import 'package:bloc_test/bloc_test.dart';
import 'package:details_repository/details_repository.dart';
import 'package:employer_details/app/app.dart';
import 'package:employer_details/details_overview/details_overview.dart';
import 'package:employer_details/settings/settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:settings_repository/settings_repository.dart';

class MockDetailsRepository extends Mock implements DetailsRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

void main() {
  late DetailsRepository mockDetailsRepository;
  late SettingsRepository mockSettingsRepository;
  late SettingsCubit mockSettingsCubit;

  setUp(() {
    mockDetailsRepository = MockDetailsRepository();
    mockSettingsRepository = MockSettingsRepository();
    mockSettingsCubit = MockSettingsCubit();

    when(() => mockSettingsCubit.state).thenReturn(const SettingsState());
  });

  group('App', () {
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          detailsRepository: mockDetailsRepository,
          settingsRepository: mockSettingsRepository,
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    testWidgets('renders DetailsOverviewPage', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: mockDetailsRepository,
          child: BlocProvider.value(
            value: mockSettingsCubit,
            child: const AppView(),
          ),
        ),
      );

      expect(find.byType(DetailsOverviewPage), findsOneWidget);
    });
  });
}
