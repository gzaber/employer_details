import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:details_repository/details_repository.dart';
import 'package:employer_details/details_overview/details_overview.dart';
import 'package:employer_details/edit_mode/edit_mode.dart';
import 'package:employer_details/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

extension PumpWidgetX on WidgetTester {
  Future<void> pumpView({
    required DetailsOverviewCubit detailsOverviewCubit,
    DetailsRepository? detailsRepository,
    SettingsCubit? settingsCubit,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: detailsRepository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: detailsOverviewCubit,
            ),
            BlocProvider.value(
              value: settingsCubit ?? MockSettingsCubit(),
            ),
          ],
          child: const MaterialApp(
            home: DetailsOverviewView(),
          ),
        ),
      ),
    );
  }
}

class MockDetailsRepository extends Mock implements DetailsRepository {}

class MockDetailsOverviewCubit extends MockCubit<DetailsOverviewState>
    implements DetailsOverviewCubit {}

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

void main() {
  group('DetailsOverviewPage', () {
    late DetailsRepository detailsRepository;

    setUp(() {
      detailsRepository = MockDetailsRepository();
    });

    testWidgets('renders DetailsOverviewView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: detailsRepository,
          child: const MaterialApp(
            home: DetailsOverviewPage(),
          ),
        ),
      );

      expect(find.byType(DetailsOverviewView), findsOneWidget);
    });
  });

  group('DetailsOverviewView', () {
    late DetailsOverviewCubit detailsOverviewCubit;

    final details = [
      Detail(
          id: 1,
          title: 'title1',
          description: 'description1',
          iconData: 11111,
          position: 1),
      Detail(
          id: 2,
          title: 'title2',
          description: 'description2',
          iconData: 22222,
          position: 2),
    ];

    setUp(() {
      detailsOverviewCubit = MockDetailsOverviewCubit();
    });

    testWidgets('renders CircularProgressIndicator when loading data',
        (tester) async {
      when(() => detailsOverviewCubit.state).thenReturn(
          const DetailsOverviewState(status: DetailsOverviewStatus.loading));

      await tester.pumpView(detailsOverviewCubit: detailsOverviewCubit);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders ListView with Cards when loaded successfully',
        (tester) async {
      when(() => detailsOverviewCubit.state).thenReturn(
        DetailsOverviewState(
          status: DetailsOverviewStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(detailsOverviewCubit: detailsOverviewCubit);

      expect(
        find.descendant(of: find.byType(ListView), matching: find.byType(Card)),
        findsNWidgets(2),
      );
    });

    testWidgets('renders HintCard when there are no details', (tester) async {
      when(() => detailsOverviewCubit.state).thenReturn(
        const DetailsOverviewState(
          status: DetailsOverviewStatus.success,
          details: [],
        ),
      );

      await tester.pumpView(detailsOverviewCubit: detailsOverviewCubit);

      expect(find.byType(HintCard), findsOneWidget);
    });

    testWidgets('shows SnackBar with info when exception occurs',
        (tester) async {
      when(() => detailsOverviewCubit.state).thenReturn(
          const DetailsOverviewState(status: DetailsOverviewStatus.loading));
      whenListen(
        detailsOverviewCubit,
        Stream.fromIterable(
          const [DetailsOverviewState(status: DetailsOverviewStatus.failure)],
        ),
      );

      await tester.pumpView(detailsOverviewCubit: detailsOverviewCubit);
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text('Something went wrong'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('navigates to EditModePage when edit menu item is tapped',
        (tester) async {
      final detailsRepository = MockDetailsRepository();
      when(() => detailsOverviewCubit.state).thenReturn(
          const DetailsOverviewState(status: DetailsOverviewStatus.success));

      await tester.pumpView(
        detailsOverviewCubit: detailsOverviewCubit,
        detailsRepository: detailsRepository,
      );

      await tester.tap(find.byType(MenuButton));
      await tester.pumpAndSettle();

      await tester
          .tap(find.byKey(const Key('detailsOverviewPageEditModeMenuItemKey')));
      await tester.pumpAndSettle();

      expect(find.byType(EditModePage), findsOneWidget);
    });

    testWidgets('performs reading details when pops from EditModePage',
        (tester) async {
      final detailsRepository = MockDetailsRepository();
      when(() => detailsOverviewCubit.state).thenReturn(
          const DetailsOverviewState(status: DetailsOverviewStatus.success));

      await tester.pumpView(
        detailsOverviewCubit: detailsOverviewCubit,
        detailsRepository: detailsRepository,
      );

      await tester.tap(find.byType(MenuButton));
      await tester.pumpAndSettle();

      await tester
          .tap(find.byKey(const Key('detailsOverviewPageEditModeMenuItemKey')));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      verify(() => detailsOverviewCubit.getDetails()).called(1);
    });

    testWidgets('navigates to SettingsPage when settings menu item is tapped',
        (tester) async {
      final settingsCubit = MockSettingsCubit();
      when(() => settingsCubit.state).thenReturn(const SettingsState());
      when(() => detailsOverviewCubit.state).thenReturn(
          const DetailsOverviewState(status: DetailsOverviewStatus.success));

      await tester.pumpView(
        detailsOverviewCubit: detailsOverviewCubit,
        settingsCubit: settingsCubit,
      );

      await tester.tap(find.byType(MenuButton));
      await tester.pumpAndSettle();

      await tester
          .tap(find.byKey(const Key('detailsOverviewPageSettingsMenuItemKey')));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsPage), findsOneWidget);
    });
  });
}
