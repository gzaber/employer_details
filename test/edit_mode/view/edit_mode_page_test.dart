import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:details_repository/details_repository.dart';
import 'package:employer_details/edit_mode/edit_mode.dart';
import 'package:employer_details/manage_detail/manage_detail.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:share_plus/share_plus.dart';

extension PumpWidgetX on WidgetTester {
  Future<void> pumpView({
    required EditModeCubit editModeCubit,
    DetailsRepository? detailsRepository,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: detailsRepository,
        child: BlocProvider.value(
          value: editModeCubit,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: EditModeView(),
          ),
        ),
      ),
    );
  }
}

class MockDetailsRepository extends Mock implements DetailsRepository {}

class MockEditModeCubit extends MockCubit<EditModeState>
    implements EditModeCubit {}

class FakeDetail extends Fake implements Detail {}

void main() {
  group('EditModePage', () {
    late DetailsRepository mockDetailsRepository;

    setUp(() {
      mockDetailsRepository = MockDetailsRepository();
    });

    testWidgets('is routable', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: mockDetailsRepository,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Builder(
              builder: (context) => Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context, EditModePage.route());
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(EditModePage), findsOneWidget);
    });

    testWidgets('renders EditModeView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: mockDetailsRepository,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: EditModePage(),
          ),
        ),
      );

      expect(find.byType(EditModeView), findsOneWidget);
    });
  });

  group('EditModeView', () {
    late DetailsRepository mockDetailsRepository;
    late EditModeCubit mockEditModeCubit;

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

    setUpAll(() {
      registerFallbackValue(FakeDetail());
    });

    setUp(() {
      mockDetailsRepository = MockDetailsRepository();
      mockEditModeCubit = MockEditModeCubit();
    });

    testWidgets('renders CircularProgressIndicator when loading data',
        (tester) async {
      when(() => mockEditModeCubit.state)
          .thenReturn(const EditModeState(status: EditModeStatus.loading));

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renders ReorderableListView with Cards when data loaded successfully',
        (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      expect(
        find.descendant(
            of: find.byType(ReorderableListView), matching: find.byType(Card)),
        findsNWidgets(2),
      );
    });

    testWidgets('renders HintCard when list of details is empty',
        (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        const EditModeState(
          status: EditModeStatus.success,
          details: [],
        ),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      expect(find.byType(HintCard), findsOneWidget);
    });

    testWidgets('shows SnackBar with info when failure occured',
        (tester) async {
      when(() => mockEditModeCubit.state)
          .thenReturn(const EditModeState(status: EditModeStatus.loading));
      whenListen(
        mockEditModeCubit,
        Stream.fromIterable(
          const [EditModeState(status: EditModeStatus.failure)],
        ),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text(AppLocalizationsEn().failureMessage),
        ),
        findsOneWidget,
      );
    });

    testWidgets('navigates to ManageDetailPage when edit menu item is tapped',
        (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(
        editModeCubit: mockEditModeCubit,
        detailsRepository: mockDetailsRepository,
      );

      await tester.tap(find.byKey(const Key('editModePageEditMenuButtonKey1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageEditMenuItemKey1')));
      await tester.pumpAndSettle();

      expect(find.byType(ManageDetailPage), findsOneWidget);
    });

    testWidgets(
        'navigates to ManageDetailPage when create detail button is tapped',
        (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(
        editModeCubit: mockEditModeCubit,
        detailsRepository: mockDetailsRepository,
      );

      await tester
          .tap(find.byKey(const Key('editModePageCreateDetailButtonKey')));
      await tester.pumpAndSettle();

      expect(find.byType(ManageDetailPage), findsOneWidget);
    });

    testWidgets(
        'reads details when pops with true from ManageDetailPage after creating detail',
        (tester) async {
      when(() => mockDetailsRepository.readAllDetails())
          .thenAnswer((_) async => []);
      when(() => mockDetailsRepository.saveDetail(any()))
          .thenAnswer((_) async => {});
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(
        editModeCubit: mockEditModeCubit,
        detailsRepository: mockDetailsRepository,
      );

      await tester
          .tap(find.byKey(const Key('editModePageCreateDetailButtonKey')));
      await tester.pumpAndSettle();

      expect(find.byType(ManageDetailPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      expect(find.byType(EditModeView), findsOneWidget);

      verify(() => mockEditModeCubit.getDetails()).called(1);
    });

    testWidgets(
        'reads details when pops with true from ManageDetailPage after updating detail',
        (tester) async {
      when(() => mockDetailsRepository.readDetail(any()))
          .thenAnswer((_) async => details.first);
      when(() => mockDetailsRepository.updateDetail(any()))
          .thenAnswer((_) async => {});
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(
        editModeCubit: mockEditModeCubit,
        detailsRepository: mockDetailsRepository,
      );

      await tester.tap(find.byKey(const Key('editModePageEditMenuButtonKey1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageEditMenuItemKey1')));
      await tester.pumpAndSettle();

      expect(find.byType(ManageDetailPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      expect(find.byType(EditModeView), findsOneWidget);

      verify(() => mockEditModeCubit.getDetails()).called(1);
    });

    testWidgets('shares detail as text when share menu item is tapped',
        (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      await tester.tap(find.byKey(const Key('editModePageEditMenuButtonKey1')));
      await tester.pumpAndSettle();

      await tester
          .tap(find.byKey(const Key('editModePageShareAsTextMenuItemKey1')));
      await tester.pumpAndSettle();

      expect(find.byType(EditModeView), findsOneWidget);
    });

    testWidgets('shows DeleteDialog when delete detail menu item is tapped',
        (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      await tester.tap(find.byKey(const Key('editModePageEditMenuButtonKey1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageDeleteMenuItemKey1')));
      await tester.pumpAndSettle();

      expect(find.byType(DeleteDialog), findsOneWidget);
    });

    testWidgets('deletes detail when pops from DeleteDialog with true',
        (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      await tester.tap(find.byKey(const Key('editModePageEditMenuButtonKey1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageDeleteMenuItemKey1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('deleteDialogApproveButtonKey')));
      await tester.pumpAndSettle();

      verify(() => mockEditModeCubit.deleteDetail(id: details.first.id!))
          .called(1);
    });

    testWidgets(
        'doesn\'t invoke cubit method when pops from DeletDialog with false',
        (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      await tester.tap(find.byKey(const Key('editModePageEditMenuButtonKey1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageDeleteMenuItemKey1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('deleteDialogDeclineButtonKey')));
      await tester.pumpAndSettle();

      verifyNever(() => mockEditModeCubit.deleteDetail(id: details.first.id!));
      verifyNever(() => mockEditModeCubit.getDetails());
    });

    testWidgets(
        'reorders details when detail item is dragged to a new position',
        (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      final TestGesture drag = await tester.startGesture(tester
          .getCenter(find.byKey(const Key('editModePageDetailItemKey0'))));
      await tester.pump(kLongPressTimeout + kPressTimeout);
      await drag.moveTo(tester
          .getCenter(find.byKey(const Key('editModePageDetailItemKey1'))));
      await drag.up();
      await tester.pumpAndSettle();

      verify(() =>
              mockEditModeCubit.updateDetailPosition(oldIndex: 0, newIndex: 1))
          .called(1);
    });

    testWidgets('shares details', (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
          xFileAllDetails: XFile.fromData(Uint8List.fromList([])),
        ),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      await tester.tap(find.byKey(const Key('editModePageMenuButtonKey')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageShareButtonKey')));
      await tester.pumpAndSettle();

      verify(() => mockEditModeCubit.convertAllDetailsToXFile()).called(1);
    });

    testWidgets('exports details', (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(
          status: EditModeStatus.success,
          details: details,
        ),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      await tester.tap(find.byKey(const Key('editModePageMenuButtonKey')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageExportButtonKey')));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppLocalizationsEn().approve));
      await tester.pumpAndSettle();

      verify(() => mockEditModeCubit.exportDetails(path: '', fileName: ''))
          .called(1);
    });

    testWidgets('shows SnackBar with export confirmation', (tester) async {
      when(() => mockEditModeCubit.state)
          .thenReturn(const EditModeState(status: EditModeStatus.loading));
      whenListen(
        mockEditModeCubit,
        Stream.fromIterable(
          const [EditModeState(isExported: true)],
        ),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(SnackBar),
          matching: find.text(AppLocalizationsEn().successfullyExported),
        ),
        findsOneWidget,
      );
    });

    testWidgets('imports details', (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        const EditModeState(status: EditModeStatus.success),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      await tester.tap(find.byKey(const Key('editModePageMenuButtonKey')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageImportButtonKey')));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppLocalizationsEn().approve));
      await tester.pumpAndSettle();

      verify(() => mockEditModeCubit.importDetails(pathToFile: '')).called(1);
    });

    testWidgets(
        'shows DeleteDialog when delete all details menu item is tapped',
        (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(status: EditModeStatus.success, details: details),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      await tester.tap(find.byKey(const Key('editModePageMenuButtonKey')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageDeleteAllButtonKey')));
      await tester.pumpAndSettle();

      expect(find.byType(DeleteDialog), findsOneWidget);
    });

    testWidgets(
        'deletes all details when pops from delete all details dialog with true',
        (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(status: EditModeStatus.success, details: details),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      await tester.tap(find.byKey(const Key('editModePageMenuButtonKey')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageDeleteAllButtonKey')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('deleteDialogApproveButtonKey')));
      await tester.pumpAndSettle();

      verify(() => mockEditModeCubit.deleteAllDetails()).called(1);
    });

    testWidgets(
        'doesn\'t invoke cubit method when pops from DeleteDialog with false',
        (tester) async {
      when(() => mockEditModeCubit.state).thenReturn(
        EditModeState(status: EditModeStatus.success, details: details),
      );

      await tester.pumpView(editModeCubit: mockEditModeCubit);

      await tester.tap(find.byKey(const Key('editModePageMenuButtonKey')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('editModePageDeleteAllButtonKey')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('deleteDialogDeclineButtonKey')));
      await tester.pumpAndSettle();

      verifyNever(() => mockEditModeCubit.deleteAllDetails());
    });
  });
}
